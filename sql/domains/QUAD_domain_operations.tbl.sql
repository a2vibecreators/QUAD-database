-- QUAD_domain_operations Table
-- Audit log of domain-level operations
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_domain_operations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    operation_type  VARCHAR(50) NOT NULL,  -- CREATE, UPDATE, DELETE, SYNC, DEPLOY
    operation_target VARCHAR(100),  -- resource name or ID
    operation_data  JSONB,  -- Additional operation details

    status          VARCHAR(20) DEFAULT 'completed',  -- pending, in_progress, completed, failed
    error_message   TEXT,

    started_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at    TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_domain_operations_domain ON QUAD_domain_operations(domain_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_domain_operations_user ON QUAD_domain_operations(user_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_domain_operations_type ON QUAD_domain_operations(operation_type);

-- Comments
COMMENT ON TABLE QUAD_domain_operations IS 'Audit log of domain-level operations';
