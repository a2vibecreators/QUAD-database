-- QUAD_deployment_recipes Table
-- Deployment configuration templates
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_deployment_recipes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    environment_id  UUID REFERENCES QUAD_environments(id) ON DELETE SET NULL,

    name            VARCHAR(100) NOT NULL,
    description     TEXT,

    recipe_type     VARCHAR(50) DEFAULT 'docker',  -- docker, kubernetes, serverless
    config          JSONB NOT NULL,

    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_deployment_recipes IS 'Deployment configuration templates';
