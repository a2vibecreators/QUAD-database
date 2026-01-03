-- Table: QUAD_user_sessions
-- Section: core
-- Purpose: JWT session tracking for authentication

CREATE TABLE QUAD_user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- Session token
    session_token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,

    -- Security tracking
    ip_address VARCHAR(50),
    user_agent TEXT,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_quad_user_sessions_user ON QUAD_user_sessions(user_id);
CREATE INDEX idx_quad_user_sessions_token ON QUAD_user_sessions(session_token);
CREATE INDEX idx_quad_user_sessions_expires ON QUAD_user_sessions(expires_at);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_user_sessions_updated_at
    BEFORE UPDATE ON QUAD_user_sessions
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_user_sessions IS 'Active user sessions. Tokens are validated against this table.';
