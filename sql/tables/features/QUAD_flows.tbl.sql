-- Table: QUAD_flows
-- Section: features
-- Purpose: Q-U-A-D workflow items (Question → Understand → Allocate → Deliver)

CREATE TABLE QUAD_flows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    -- Flow identification
    title VARCHAR(500) NOT NULL,
    description TEXT,
    flow_type VARCHAR(50) DEFAULT 'feature',
    -- 'feature', 'bug', 'task', 'story', 'epic', 'spike'

    -- Q-U-A-D Stage tracking
    quad_stage VARCHAR(1) NOT NULL DEFAULT 'Q',
    -- 'Q' = Question, 'U' = Understand, 'A' = Allocate, 'D' = Deliver

    stage_status VARCHAR(20) DEFAULT 'pending',
    -- 'pending', 'in_progress', 'completed', 'blocked'

    -- Stage timestamps
    question_started_at TIMESTAMP,
    question_completed_at TIMESTAMP,
    understand_started_at TIMESTAMP,
    understand_completed_at TIMESTAMP,
    allocate_started_at TIMESTAMP,
    allocate_completed_at TIMESTAMP,
    deliver_started_at TIMESTAMP,
    deliver_completed_at TIMESTAMP,

    -- Assignment
    assigned_to UUID REFERENCES QUAD_users(id),
    circle_number INT,
    -- 1 = Management, 2 = Development, 3 = QA, 4 = Infrastructure

    -- Priority and estimation
    priority VARCHAR(20) DEFAULT 'medium',
    -- 'critical', 'high', 'medium', 'low'

    ai_estimate_hours DECIMAL(5,2),        -- AI's raw estimate
    buffer_pct INT,                        -- Buffer from user's adoption matrix
    final_estimate_hours DECIMAL(5,2) GENERATED ALWAYS AS (
        ai_estimate_hours * (1 + COALESCE(buffer_pct, 40)::DECIMAL / 100)
    ) STORED,
    actual_hours DECIMAL(5,2),             -- Actual time spent

    -- External integration
    external_id VARCHAR(100),              -- Jira ticket ID, GitHub issue, etc.
    external_url TEXT,

    -- Metadata
    created_by UUID REFERENCES QUAD_users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_quad_flows_domain ON QUAD_flows(domain_id);
CREATE INDEX idx_quad_flows_stage ON QUAD_flows(quad_stage);
CREATE INDEX idx_quad_flows_status ON QUAD_flows(stage_status);
CREATE INDEX idx_quad_flows_assigned ON QUAD_flows(assigned_to);
CREATE INDEX idx_quad_flows_circle ON QUAD_flows(circle_number);
CREATE INDEX idx_quad_flows_priority ON QUAD_flows(priority);
CREATE INDEX idx_quad_flows_external ON QUAD_flows(external_id);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_flows_updated_at
    BEFORE UPDATE ON QUAD_flows
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_flows IS 'Q-U-A-D workflow items. Tracks progression through Question → Understand → Allocate → Deliver stages.';
COMMENT ON COLUMN QUAD_flows.buffer_pct IS 'Safety buffer from user adoption matrix. Applied to AI estimate.';
