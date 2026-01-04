-- QUAD_deployments Table
-- Deployment records
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_deployments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    environment_id  UUID NOT NULL REFERENCES QUAD_environments(id) ON DELETE CASCADE,
    recipe_id       UUID REFERENCES QUAD_deployment_recipes(id) ON DELETE SET NULL,

    version         VARCHAR(50),
    commit_sha      VARCHAR(40),
    branch          VARCHAR(255),

    status          VARCHAR(20) DEFAULT 'pending',  -- pending, deploying, success, failed, rolled_back
    started_at      TIMESTAMP WITH TIME ZONE,
    completed_at    TIMESTAMP WITH TIME ZONE,
    error_message   TEXT,

    deployed_by     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_deployments IS 'Deployment records';
