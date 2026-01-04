-- QUAD_database_approvals Table
-- Database operation approvals
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_database_approvals (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operation_id    UUID NOT NULL REFERENCES QUAD_database_operations(id) ON DELETE CASCADE,

    requester_id    UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    approver_id     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    status          VARCHAR(20) DEFAULT 'pending',
    decision_at     TIMESTAMP WITH TIME ZONE,
    decision_reason TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_database_approvals IS 'Database operation approvals';
