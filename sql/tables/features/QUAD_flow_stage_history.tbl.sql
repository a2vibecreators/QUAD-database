-- Table: QUAD_flow_stage_history
-- Section: features
-- Purpose: Audit trail of stage transitions for flows

CREATE TABLE QUAD_flow_stage_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    flow_id UUID NOT NULL REFERENCES QUAD_flows(id) ON DELETE CASCADE,

    -- Transition details
    from_stage VARCHAR(1),           -- NULL for initial creation
    to_stage VARCHAR(1) NOT NULL,
    from_status VARCHAR(20),
    to_status VARCHAR(20) NOT NULL,

    -- Who and why
    changed_by UUID REFERENCES QUAD_users(id),
    change_reason TEXT,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_quad_flow_history_flow ON QUAD_flow_stage_history(flow_id);
CREATE INDEX idx_quad_flow_history_stage ON QUAD_flow_stage_history(to_stage);
CREATE INDEX idx_quad_flow_history_changed_by ON QUAD_flow_stage_history(changed_by);

-- Comments
COMMENT ON TABLE QUAD_flow_stage_history IS 'Audit trail tracking all Q-U-A-D stage transitions.';
