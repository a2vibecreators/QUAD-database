-- QUAD_user_sessions Table
-- Active login sessions for JWT token management
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_user_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,
    session_token   VARCHAR(255) NOT NULL,
    expires_at      TIMESTAMP NOT NULL,
    ip_address      VARCHAR(50),
    user_agent      TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_user_sessions_user ON quad_user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_quad_user_sessions_token ON quad_user_sessions(session_token);
CREATE INDEX IF NOT EXISTS idx_quad_user_sessions_expires ON quad_user_sessions(expires_at);

-- Comments
COMMENT ON TABLE quad_user_sessions IS 'Active login sessions for JWT token management';
