-- QUAD Sandbox Auto-Scale Functions
-- Background job functions for dynamic sandbox management
--
-- Functions:
--   1. check_sandbox_idle_status()   - Mark sandboxes as idle based on activity
--   2. get_sandboxes_to_terminate()  - Find idle sandboxes above min pool
--   3. get_scaling_recommendations() - Get scaling advice for an org
--
-- Part of: QUAD Infrastructure System
-- Created: January 3, 2026

-- ============================================================================
-- FUNCTION 1: Mark sandboxes as idle
-- ============================================================================
-- Called every 5 minutes by background job
-- Checks last_activity_at and marks status = 'idle' if inactive

CREATE OR REPLACE FUNCTION check_sandbox_idle_status(
    p_idle_threshold_minutes INTEGER DEFAULT 30  -- Minutes of inactivity = idle
)
RETURNS TABLE (
    sandbox_id UUID,
    org_id UUID,
    mode VARCHAR(20),
    minutes_idle INTEGER,
    newly_marked_idle BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    WITH idle_candidates AS (
        SELECT
            si.id,
            si.org_id,
            si.mode,
            EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - si.last_activity_at)) / 60 AS mins_idle,
            si.status
        FROM QUAD_sandbox_instances si
        WHERE si.status = 'running'
          AND si.last_activity_at < CURRENT_TIMESTAMP - (p_idle_threshold_minutes || ' minutes')::INTERVAL
    ),
    updated AS (
        UPDATE QUAD_sandbox_instances si
        SET status = 'idle',
            idle_since = CURRENT_TIMESTAMP
        FROM idle_candidates ic
        WHERE si.id = ic.id
          AND si.status = 'running'  -- Only update if still running
        RETURNING si.id, si.org_id, si.mode, ic.mins_idle::INTEGER
    )
    SELECT
        u.id AS sandbox_id,
        u.org_id,
        u.mode,
        u.mins_idle AS minutes_idle,
        true AS newly_marked_idle
    FROM updated u

    UNION ALL

    -- Also return already-idle sandboxes for reporting
    SELECT
        si.id AS sandbox_id,
        si.org_id,
        si.mode,
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - si.idle_since))::INTEGER / 60 AS minutes_idle,
        false AS newly_marked_idle
    FROM QUAD_sandbox_instances si
    WHERE si.status = 'idle';
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FUNCTION 2: Get sandboxes eligible for termination
-- ============================================================================
-- Returns idle sandboxes that can be terminated (above min pool)
-- Called by auto-scale job to decide what to shut down

CREATE OR REPLACE FUNCTION get_sandboxes_to_terminate(
    p_org_id UUID DEFAULT NULL  -- NULL = all orgs
)
RETURNS TABLE (
    sandbox_id UUID,
    org_id UUID,
    mode VARCHAR(20),
    idle_hours DECIMAL(6,2),
    termination_reason VARCHAR(100),
    priority INTEGER  -- Lower = terminate first
) AS $$
BEGIN
    RETURN QUERY
    WITH org_config AS (
        -- Get each org's config
        SELECT
            ic.org_id,
            ic.sandbox_pool_size AS min_pool,
            ic.sandbox_dedicated_timeout_hours AS timeout_hours
        FROM QUAD_infrastructure_config ic
        WHERE p_org_id IS NULL OR ic.org_id = p_org_id
    ),
    sandbox_counts AS (
        -- Count running + idle sandboxes per org per mode
        SELECT
            si.org_id,
            si.mode,
            COUNT(*) FILTER (WHERE si.status IN ('running', 'idle')) AS active_count,
            COUNT(*) FILTER (WHERE si.status = 'idle') AS idle_count
        FROM QUAD_sandbox_instances si
        WHERE p_org_id IS NULL OR si.org_id = p_org_id
        GROUP BY si.org_id, si.mode
    ),
    termination_candidates AS (
        SELECT
            si.id,
            si.org_id,
            si.mode,
            EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - si.idle_since)) / 3600 AS idle_hrs,
            oc.min_pool,
            oc.timeout_hours,
            sc.active_count,
            sc.idle_count,
            -- Priority: older idle sandboxes first, then by mode
            ROW_NUMBER() OVER (
                PARTITION BY si.org_id, si.mode
                ORDER BY si.idle_since ASC
            ) AS idle_rank
        FROM QUAD_sandbox_instances si
        JOIN org_config oc ON oc.org_id = si.org_id
        LEFT JOIN sandbox_counts sc ON sc.org_id = si.org_id AND sc.mode = si.mode
        WHERE si.status = 'idle'
          AND si.idle_since IS NOT NULL
    )
    SELECT
        tc.id AS sandbox_id,
        tc.org_id,
        tc.mode,
        tc.idle_hrs::DECIMAL(6,2) AS idle_hours,
        CASE
            -- PR sandboxes: always terminate after timeout
            WHEN tc.mode = 'pr_sandbox' AND tc.idle_hrs >= tc.timeout_hours
                THEN 'idle_timeout'
            -- Shared pool: terminate if above min pool
            WHEN tc.mode = 'shared' AND tc.active_count > tc.min_pool
                THEN 'scale_down'
            -- Devbox: terminate after timeout
            WHEN tc.mode = 'devbox' AND tc.idle_hrs >= tc.timeout_hours
                THEN 'idle_timeout'
            ELSE NULL
        END AS termination_reason,
        tc.idle_rank::INTEGER AS priority
    FROM termination_candidates tc
    WHERE
        -- PR sandbox: terminate if idle > timeout
        (tc.mode = 'pr_sandbox' AND tc.idle_hrs >= tc.timeout_hours)
        -- Shared: terminate if above min pool AND oldest idle first
        OR (tc.mode = 'shared' AND tc.active_count > tc.min_pool AND tc.idle_rank <= (tc.active_count - tc.min_pool))
        -- Devbox: terminate if idle > timeout
        OR (tc.mode = 'devbox' AND tc.idle_hrs >= tc.timeout_hours)
    ORDER BY tc.org_id, priority;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FUNCTION 3: Get scaling recommendations
-- ============================================================================
-- Returns summary of current state and recommended actions

CREATE OR REPLACE FUNCTION get_scaling_recommendations(
    p_org_id UUID
)
RETURNS TABLE (
    mode VARCHAR(20),
    running_count INTEGER,
    idle_count INTEGER,
    min_pool INTEGER,
    can_scale_down BOOLEAN,
    scale_down_count INTEGER,
    recommendation TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH org_config AS (
        SELECT
            ic.sandbox_pool_size AS min_pool,
            ic.sandbox_dedicated_timeout_hours AS timeout_hours
        FROM QUAD_infrastructure_config ic
        WHERE ic.org_id = p_org_id
    ),
    sandbox_stats AS (
        SELECT
            si.mode,
            COUNT(*) FILTER (WHERE si.status = 'running') AS running,
            COUNT(*) FILTER (WHERE si.status = 'idle') AS idle,
            COUNT(*) FILTER (WHERE si.status IN ('running', 'idle')) AS active
        FROM QUAD_sandbox_instances si
        WHERE si.org_id = p_org_id
        GROUP BY si.mode
    )
    SELECT
        ss.mode,
        ss.running::INTEGER AS running_count,
        ss.idle::INTEGER AS idle_count,
        COALESCE(oc.min_pool, 0)::INTEGER AS min_pool,
        (ss.active > COALESCE(oc.min_pool, 0) AND ss.idle > 0) AS can_scale_down,
        GREATEST(0, ss.active - COALESCE(oc.min_pool, 0))::INTEGER AS scale_down_count,
        CASE
            WHEN ss.active > COALESCE(oc.min_pool, 0) AND ss.idle > 0
                THEN 'Can terminate ' || GREATEST(0, ss.active - COALESCE(oc.min_pool, 0)) || ' idle sandbox(es)'
            WHEN ss.active < COALESCE(oc.min_pool, 0)
                THEN 'Need to provision ' || (COALESCE(oc.min_pool, 0) - ss.active) || ' more sandbox(es)'
            ELSE 'Pool is at optimal size'
        END AS recommendation
    FROM sandbox_stats ss
    CROSS JOIN org_config oc
    ORDER BY ss.mode;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FUNCTION 4: Record activity (call this on every API request to sandbox)
-- ============================================================================

CREATE OR REPLACE FUNCTION record_sandbox_activity(
    p_sandbox_id UUID
)
RETURNS VOID AS $$
BEGIN
    UPDATE QUAD_sandbox_instances
    SET
        last_activity_at = CURRENT_TIMESTAMP,
        activity_count = activity_count + 1,
        activity_count_hour = activity_count_hour + 1,
        -- If was idle, mark as running again
        status = CASE WHEN status = 'idle' THEN 'running' ELSE status END,
        idle_since = CASE WHEN status = 'idle' THEN NULL ELSE idle_since END
    WHERE id = p_sandbox_id
      AND status IN ('running', 'idle');
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON FUNCTION check_sandbox_idle_status IS 'Mark inactive sandboxes as idle. Run every 5 minutes.';
COMMENT ON FUNCTION get_sandboxes_to_terminate IS 'Get list of sandboxes eligible for termination based on idle time and pool size.';
COMMENT ON FUNCTION get_scaling_recommendations IS 'Get scaling advice for an organization.';
COMMENT ON FUNCTION record_sandbox_activity IS 'Call on every API request to update sandbox activity timestamp.';
