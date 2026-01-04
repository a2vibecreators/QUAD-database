-- QUAD_flow_stage_history Table
-- Audit trail tracking all Q-U-A-D stage transitions
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_flow_stage_history (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    flow_id         UUID NOT NULL REFERENCES quad_flows(id) ON DELETE CASCADE,
    from_stage      VARCHAR(1),      -- Q, U, A, D or NULL for initial
    to_stage        VARCHAR(1) NOT NULL,
    from_status     VARCHAR(20),
    to_status       VARCHAR(20) NOT NULL,
    changed_by      UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    change_reason   TEXT,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_flow_stage_history_flow ON quad_flow_stage_history(flow_id);
CREATE INDEX IF NOT EXISTS idx_quad_flow_stage_history_created ON quad_flow_stage_history(created_at);

-- Comments
COMMENT ON TABLE quad_flow_stage_history IS 'Audit trail tracking all Q-U-A-D stage transitions.';
