-- QUAD_approvals Table
-- Generic approval workflow
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_approvals (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    approval_type   VARCHAR(50) NOT NULL,  -- deployment, pr_merge, access_request
    resource_type   VARCHAR(50) NOT NULL,
    resource_id     UUID NOT NULL,

    requester_id    UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    approver_id     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    status          VARCHAR(20) DEFAULT 'pending',  -- pending, approved, rejected, expired
    decision_at     TIMESTAMP WITH TIME ZONE,
    decision_reason TEXT,

    expires_at      TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_approvals IS 'Generic approval workflow';
