-- QUAD_environments Table
-- Deployment environments
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_environments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    name            VARCHAR(100) NOT NULL,
    env_type        VARCHAR(20) DEFAULT 'development',  -- development, staging, production
    description     TEXT,

    url             TEXT,
    is_protected    BOOLEAN DEFAULT false,
    requires_approval BOOLEAN DEFAULT false,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(domain_id, name)
);

COMMENT ON TABLE QUAD_environments IS 'Deployment environments';
