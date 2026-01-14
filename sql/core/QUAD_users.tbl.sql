-- QUAD_users Table
-- User accounts with email/password authentication
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID REFERENCES quad_organizations(id) ON DELETE SET NULL,
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255),
    name            VARCHAR(255),
    role            VARCHAR(50),
    avatar_url      VARCHAR(255),
    department      VARCHAR(255),
    job_title       VARCHAR(255),
    github_username VARCHAR(255),
    slack_user_id   VARCHAR(255),
    timezone        VARCHAR(255),
    is_active       BOOLEAN DEFAULT true,
    is_admin        BOOLEAN DEFAULT false,
    email_verified  BOOLEAN DEFAULT false,
    last_login_at   TIMESTAMP,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_users_email ON quad_users(email);
CREATE INDEX IF NOT EXISTS idx_quad_users_org ON quad_users(org_id);
CREATE INDEX IF NOT EXISTS idx_quad_users_github ON quad_users(github_username);

-- Comments
COMMENT ON TABLE quad_users IS 'User accounts with email/password authentication';
