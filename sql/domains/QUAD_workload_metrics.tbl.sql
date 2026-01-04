-- QUAD_workload_metrics Table
-- Track Assignments vs Completes vs Output per user per period
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_workload_metrics (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,
    domain_id       UUID REFERENCES quad_domains(id) ON DELETE SET NULL,

    -- Time period
    period_start    DATE NOT NULL,
    period_end      DATE NOT NULL,
    period_type     VARCHAR(20) DEFAULT 'week',  -- day, week, sprint, month

    -- Workload metrics
    tickets_assigned    INTEGER DEFAULT 0,
    tickets_completed   INTEGER DEFAULT 0,
    story_points_assigned INTEGER DEFAULT 0,
    story_points_completed INTEGER DEFAULT 0,
    hours_estimated     NUMERIC(6,2) DEFAULT 0,
    hours_actual        NUMERIC(6,2) DEFAULT 0,

    -- Analysis
    completion_rate     NUMERIC(5,2) GENERATED ALWAYS AS (
        CASE WHEN tickets_assigned > 0
            THEN (tickets_completed::NUMERIC / tickets_assigned::NUMERIC) * 100
            ELSE 0
        END
    ) STORED,

    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),

    UNIQUE(user_id, domain_id, period_start, period_type)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_workload_user ON quad_workload_metrics(user_id);
CREATE INDEX IF NOT EXISTS idx_quad_workload_domain ON quad_workload_metrics(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_workload_period ON quad_workload_metrics(period_start, period_end);

-- Comments
COMMENT ON TABLE quad_workload_metrics IS 'Track Assignments vs Completes vs Output per user per period';
