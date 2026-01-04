-- QUAD_rollback_operations Table
-- Rollback operations
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_rollback_operations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deployment_id   UUID NOT NULL REFERENCES QUAD_deployments(id) ON DELETE CASCADE,
    rollback_to_id  UUID REFERENCES QUAD_deployments(id) ON DELETE SET NULL,

    reason          TEXT,
    status          VARCHAR(20) DEFAULT 'pending',  -- pending, in_progress, completed, failed

    started_at      TIMESTAMP WITH TIME ZONE,
    completed_at    TIMESTAMP WITH TIME ZONE,
    error_message   TEXT,

    initiated_by    UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_rollback_operations IS 'Rollback operations';
