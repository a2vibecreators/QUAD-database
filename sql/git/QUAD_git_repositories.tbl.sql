-- QUAD_git_repositories Table
-- Git repositories linked to domains
--
-- Part of: QUAD Git
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_git_repositories (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    integration_id  UUID NOT NULL REFERENCES QUAD_git_integrations(id) ON DELETE CASCADE,

    repo_name       VARCHAR(255) NOT NULL,
    repo_full_name  VARCHAR(500),  -- org/repo
    repo_url        TEXT,
    default_branch  VARCHAR(100) DEFAULT 'main',

    is_primary      BOOLEAN DEFAULT false,
    is_active       BOOLEAN DEFAULT true,

    last_commit_sha VARCHAR(40),
    last_commit_at  TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_git_repositories IS 'Git repositories linked to domains';
