-- QUAD_domain_resources Table
-- Resources belonging to domains (projects, integrations, repos)
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_domain_resources (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    resource_type   VARCHAR(50) NOT NULL,  -- project, git_repo, slack_channel, jira_project
    resource_name   VARCHAR(255) NOT NULL,
    resource_status VARCHAR(50) DEFAULT 'pending_setup',  -- pending_setup, active, disabled
    created_by      UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_domain_resources_domain ON quad_domain_resources(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_domain_resources_type ON quad_domain_resources(resource_type);

-- Comments
COMMENT ON TABLE quad_domain_resources IS 'Resources belonging to domains (projects, integrations, repos). Uses EAV pattern for flexible configuration.';
