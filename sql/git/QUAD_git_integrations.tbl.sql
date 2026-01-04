-- QUAD_git_integrations Table
-- Git provider integrations (GitHub, GitLab, Bitbucket)
--
-- Part of: QUAD Git
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_git_integrations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    provider        VARCHAR(20) NOT NULL,  -- github, gitlab, bitbucket
    provider_org    VARCHAR(100),  -- GitHub org name

    -- OAuth tokens (stored in vault)
    access_token_vault_path VARCHAR(255),
    refresh_token_vault_path VARCHAR(255),

    -- Webhook
    webhook_secret_vault_path VARCHAR(255),
    webhook_url     TEXT,

    status          VARCHAR(20) DEFAULT 'active',
    last_sync_at    TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_git_integrations IS 'Git provider integrations (GitHub, GitLab, Bitbucket)';
