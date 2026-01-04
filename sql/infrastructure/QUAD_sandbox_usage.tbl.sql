-- QUAD_sandbox_usage Table
-- Tracks resource usage metrics per sandbox for monitoring and billing
--
-- Metrics collected every 5 minutes by background job
-- Used for:
--   - Idle detection (low CPU/memory = idle)
--   - Cost calculation
--   - Capacity planning
--   - Usage reports
--
-- Part of: QUAD Infrastructure System
-- Created: January 3, 2026

CREATE TABLE IF NOT EXISTS QUAD_sandbox_usage (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sandbox_id          UUID NOT NULL REFERENCES quad_sandbox_instances(id) ON DELETE CASCADE,
    org_id              UUID NOT NULL REFERENCES quad_organizations(id) ON DELETE CASCADE,

    -- ========================================================================
    -- TIMESTAMP
    -- ========================================================================
    recorded_at         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    period_minutes      INTEGER DEFAULT 5,          -- Collection interval

    -- ========================================================================
    -- CPU METRICS
    -- ========================================================================
    cpu_percent         DECIMAL(5,2),               -- 0-100 (can exceed 100 with multiple cores)
    cpu_cores_used      DECIMAL(4,2),               -- Actual cores utilized
    cpu_throttled_ms    INTEGER DEFAULT 0,          -- Time spent throttled

    -- ========================================================================
    -- MEMORY METRICS
    -- ========================================================================
    memory_used_mb      INTEGER,
    memory_available_mb INTEGER,
    memory_percent      DECIMAL(5,2),               -- 0-100
    memory_swap_mb      INTEGER DEFAULT 0,

    -- ========================================================================
    -- DISK METRICS
    -- ========================================================================
    disk_used_gb        DECIMAL(6,2),
    disk_available_gb   DECIMAL(6,2),
    disk_percent        DECIMAL(5,2),
    disk_read_mb        DECIMAL(10,2),              -- MB read in period
    disk_write_mb       DECIMAL(10,2),              -- MB written in period

    -- ========================================================================
    -- NETWORK METRICS
    -- ========================================================================
    network_in_mb       DECIMAL(10,2),              -- MB received in period
    network_out_mb      DECIMAL(10,2),              -- MB sent in period
    network_requests    INTEGER DEFAULT 0,          -- HTTP requests in period

    -- ========================================================================
    -- APPLICATION METRICS
    -- ========================================================================
    api_calls           INTEGER DEFAULT 0,          -- API calls in period
    build_count         INTEGER DEFAULT 0,          -- Builds triggered
    test_runs           INTEGER DEFAULT 0,          -- Test executions
    ai_requests         INTEGER DEFAULT 0,          -- AI API calls

    -- ========================================================================
    -- HEALTH STATUS
    -- ========================================================================
    health_status       VARCHAR(20) DEFAULT 'healthy',
    -- 'healthy', 'degraded', 'unhealthy', 'unknown'

    health_checks_passed INTEGER DEFAULT 0,
    health_checks_failed INTEGER DEFAULT 0,
    error_count         INTEGER DEFAULT 0,

    -- ========================================================================
    -- IDLE DETECTION
    -- ========================================================================
    is_idle             BOOLEAN DEFAULT false,
    idle_score          DECIMAL(5,2),               -- 0-100 (100 = completely idle)
    -- Calculated: low CPU + low memory + no API calls = high idle score

    -- ========================================================================
    -- COST
    -- ========================================================================
    period_cost_usd     DECIMAL(10,6),              -- Cost for this period

    -- ========================================================================
    -- METADATA
    -- ========================================================================
    metadata            JSONB DEFAULT '{}',

    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Time-series queries
CREATE INDEX IF NOT EXISTS idx_sandbox_usage_time ON QUAD_sandbox_usage(recorded_at DESC);
CREATE INDEX IF NOT EXISTS idx_sandbox_usage_sandbox_time ON QUAD_sandbox_usage(sandbox_id, recorded_at DESC);

-- Org-level aggregations
CREATE INDEX IF NOT EXISTS idx_sandbox_usage_org ON QUAD_sandbox_usage(org_id, recorded_at DESC);

-- Idle detection
CREATE INDEX IF NOT EXISTS idx_sandbox_usage_idle ON QUAD_sandbox_usage(sandbox_id, is_idle) WHERE is_idle = true;

-- Cost queries
CREATE INDEX IF NOT EXISTS idx_sandbox_usage_cost ON QUAD_sandbox_usage(org_id, recorded_at, period_cost_usd);

-- ============================================================================
-- PARTITIONING (Optional - for high volume)
-- ============================================================================

-- Consider partitioning by month for large deployments:
-- CREATE TABLE QUAD_sandbox_usage_YYYY_MM PARTITION OF QUAD_sandbox_usage
--     FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

-- ============================================================================
-- RETENTION POLICY
-- ============================================================================

-- Function to delete old usage records (keep 90 days)
CREATE OR REPLACE FUNCTION cleanup_old_sandbox_usage()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM QUAD_sandbox_usage
    WHERE recorded_at < CURRENT_TIMESTAMP - INTERVAL '90 days';

    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- AGGREGATION VIEWS
-- ============================================================================

-- Hourly aggregation view
CREATE OR REPLACE VIEW v_sandbox_usage_hourly AS
SELECT
    sandbox_id,
    org_id,
    date_trunc('hour', recorded_at) AS hour,
    AVG(cpu_percent) AS avg_cpu_percent,
    MAX(cpu_percent) AS max_cpu_percent,
    AVG(memory_percent) AS avg_memory_percent,
    MAX(memory_percent) AS max_memory_percent,
    SUM(api_calls) AS total_api_calls,
    SUM(period_cost_usd) AS total_cost_usd,
    COUNT(*) FILTER (WHERE is_idle) AS idle_periods,
    COUNT(*) AS total_periods
FROM QUAD_sandbox_usage
GROUP BY sandbox_id, org_id, date_trunc('hour', recorded_at);

-- Daily summary view
CREATE OR REPLACE VIEW v_sandbox_usage_daily AS
SELECT
    sandbox_id,
    org_id,
    date_trunc('day', recorded_at) AS day,
    AVG(cpu_percent) AS avg_cpu_percent,
    MAX(cpu_percent) AS max_cpu_percent,
    AVG(memory_percent) AS avg_memory_percent,
    SUM(api_calls) AS total_api_calls,
    SUM(period_cost_usd) AS total_cost_usd,
    SUM(CASE WHEN is_idle THEN period_minutes ELSE 0 END) AS idle_minutes,
    SUM(period_minutes) AS total_minutes
FROM QUAD_sandbox_usage
GROUP BY sandbox_id, org_id, date_trunc('day', recorded_at);

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON TABLE QUAD_sandbox_usage IS 'Time-series metrics for sandbox resource usage and idle detection';
COMMENT ON COLUMN QUAD_sandbox_usage.idle_score IS '0-100 score where 100 = completely idle (low CPU, memory, no API calls)';
COMMENT ON COLUMN QUAD_sandbox_usage.period_cost_usd IS 'Estimated cost for this collection period';
COMMENT ON VIEW v_sandbox_usage_hourly IS 'Hourly aggregated sandbox metrics';
COMMENT ON VIEW v_sandbox_usage_daily IS 'Daily aggregated sandbox metrics';
