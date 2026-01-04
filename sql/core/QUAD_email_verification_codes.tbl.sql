-- QUAD_email_verification_codes Table
-- Email verification codes for passwordless login
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_email_verification_codes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           VARCHAR(255) NOT NULL,
    code            VARCHAR(10) NOT NULL,  -- 6-digit code

    purpose         VARCHAR(50) DEFAULT 'login',  -- login, signup, password_reset

    expires_at      TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at         TIMESTAMP WITH TIME ZONE,

    -- Rate limiting
    attempt_count   INTEGER DEFAULT 0,
    last_attempt_at TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_email_verification_email ON QUAD_email_verification_codes(email);
CREATE INDEX IF NOT EXISTS idx_QUAD_email_verification_code ON QUAD_email_verification_codes(code);
CREATE INDEX IF NOT EXISTS idx_QUAD_email_verification_expires ON QUAD_email_verification_codes(expires_at);

-- Comments
COMMENT ON TABLE QUAD_email_verification_codes IS 'Email verification codes for passwordless login';
