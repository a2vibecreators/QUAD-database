-- QUAD_github_tokens Table
-- Stores GitHub OAuth access tokens securely
-- Enables GitHub SSO and automatic contribution tracking
--
-- Part of: QUAD GitHub Integration
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_github_tokens (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL UNIQUE REFERENCES quad_users(id) ON DELETE CASCADE,

    -- GitHub identifiers
    github_id           INTEGER NOT NULL UNIQUE,
    github_username     VARCHAR(255) NOT NULL UNIQUE,
    github_avatar_url   VARCHAR(500),

    -- OAuth tokens (encrypted in production)
    access_token        TEXT NOT NULL,              -- Should be encrypted at rest
    refresh_token       TEXT,
    token_type          VARCHAR(50) DEFAULT 'bearer',

    -- Token metadata
    scopes              VARCHAR(500),               -- Space-separated scopes
    expires_at          TIMESTAMP,

    -- Tracking
    last_synced_at      TIMESTAMP,
    sync_enabled        BOOLEAN DEFAULT true,       -- Allow background fairness sync

    -- Status
    is_active           BOOLEAN DEFAULT true,

    -- Timestamps
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    created_at_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_github_tokens_user ON QUAD_github_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_github_tokens_github_id ON QUAD_github_tokens(github_id);
CREATE INDEX IF NOT EXISTS idx_github_tokens_username ON QUAD_github_tokens(github_username);
CREATE INDEX IF NOT EXISTS idx_github_tokens_active ON QUAD_github_tokens(is_active);

COMMENT ON TABLE QUAD_github_tokens IS 'GitHub OAuth tokens for SSO and contribution tracking';
