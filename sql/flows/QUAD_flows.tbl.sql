-- QUAD_flows Table
-- Q-U-A-D workflow items
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_flows (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id               UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    title                   VARCHAR(500) NOT NULL,
    description             TEXT,
    flow_type               VARCHAR(50) DEFAULT 'feature',  -- feature, bug, spike, task

    -- Q-U-A-D Stage Tracking
    quad_stage              VARCHAR(1) DEFAULT 'Q' NOT NULL,  -- Q, U, A, D
    stage_status            VARCHAR(20) DEFAULT 'pending',
    question_started_at     TIMESTAMP,
    question_completed_at   TIMESTAMP,
    understand_started_at   TIMESTAMP,
    understand_completed_at TIMESTAMP,
    allocate_started_at     TIMESTAMP,
    allocate_completed_at   TIMESTAMP,
    deliver_started_at      TIMESTAMP,
    deliver_completed_at    TIMESTAMP,

    -- Assignment
    assigned_to             UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    circle_number           INTEGER,  -- 1=Management, 2=Development, 3=QA, 4=Infrastructure
    priority                VARCHAR(20) DEFAULT 'medium',

    -- AI Estimation
    ai_estimate_hours       NUMERIC(5,2),
    buffer_pct              INTEGER,  -- Safety buffer from adoption matrix
    final_estimate_hours    NUMERIC(5,2) GENERATED ALWAYS AS (
        ai_estimate_hours * (1 + COALESCE(buffer_pct, 40)::NUMERIC / 100)
    ) STORED,
    actual_hours            NUMERIC(5,2),

    -- External tracking
    external_id             VARCHAR(100),
    external_url            TEXT,

    created_by              UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    created_at              TIMESTAMP DEFAULT NOW(),
    updated_at              TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_flows_domain ON quad_flows(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_flows_stage ON quad_flows(quad_stage);
CREATE INDEX IF NOT EXISTS idx_quad_flows_assigned ON quad_flows(assigned_to);
CREATE INDEX IF NOT EXISTS idx_quad_flows_priority ON quad_flows(priority);

-- Comments
COMMENT ON TABLE quad_flows IS 'Q-U-A-D workflow items. Tracks progression through Question → Understand → Allocate → Deliver stages.';
COMMENT ON COLUMN quad_flows.buffer_pct IS 'Safety buffer from user adoption matrix. Applied to AI estimate.';
