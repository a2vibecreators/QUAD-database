-- Table: QUAD_workload_metrics
-- Section: features
-- Purpose: Track Assignments vs Completes vs Output per user per period

CREATE TABLE QUAD_workload_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    domain_id UUID REFERENCES QUAD_domains(id) ON DELETE SET NULL,

    -- Time period
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    period_type VARCHAR(20) DEFAULT 'week',
    -- 'day', 'week', 'sprint', 'month'

    -- Core metrics (the 3 pillars)
    assignments INT DEFAULT 0,      -- Tasks assigned to user
    completes INT DEFAULT 0,        -- Tasks completed by user
    output_score DECIMAL(5,2),      -- Quality/productivity rating (0-100)

    -- Derived metrics
    completion_rate DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE WHEN assignments > 0 THEN (completes::DECIMAL / assignments) * 100 ELSE 0 END
    ) STORED,

    -- 4-4-4 Principle tracking
    hours_worked DECIMAL(5,2) DEFAULT 0,    -- Actual hours worked
    target_hours DECIMAL(5,2) DEFAULT 16,   -- Target: 4 hrs × 4 days = 16
    days_worked INT DEFAULT 0,              -- Actual days
    target_days INT DEFAULT 4,              -- Target: 4 days

    -- Efficiency calculation
    efficiency_multiplier DECIMAL(5,2) GENERATED ALWAYS AS (
        CASE WHEN hours_worked > 0 THEN output_score / (hours_worked / 4) ELSE 0 END
    ) STORED,

    -- Root cause analysis (when completion_rate < 80%)
    root_cause VARCHAR(50),
    -- 'SKILL_GAP', 'OVERLOAD', 'BLOCKER', 'SCOPE_CREEP', 'EXTERNAL_DEPENDENCY', 'PERSONAL'

    root_cause_notes TEXT,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_period CHECK (period_end >= period_start),
    CONSTRAINT valid_assignments CHECK (assignments >= 0),
    CONSTRAINT valid_completes CHECK (completes >= 0),
    UNIQUE(user_id, domain_id, period_start, period_end)
);

-- Indexes
CREATE INDEX idx_quad_workload_user ON QUAD_workload_metrics(user_id);
CREATE INDEX idx_quad_workload_domain ON QUAD_workload_metrics(domain_id);
CREATE INDEX idx_quad_workload_period ON QUAD_workload_metrics(period_start, period_end);
CREATE INDEX idx_quad_workload_root_cause ON QUAD_workload_metrics(root_cause);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_workload_metrics_updated_at
    BEFORE UPDATE ON QUAD_workload_metrics
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_workload_metrics IS 'Tracks Assignments vs Completes vs Output. Enables 4-4-4 principle validation and root cause analysis.';
COMMENT ON COLUMN QUAD_workload_metrics.root_cause IS 'When completion_rate < 80%, identifies why: SKILL_GAP, OVERLOAD, BLOCKER, etc.';
