-- QUAD_verification_requests Table
-- Identity/credential verification requests
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_verification_requests (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    verification_type VARCHAR(50) NOT NULL,  -- email, github, linkedin
    verification_value VARCHAR(255),

    token           VARCHAR(255) UNIQUE,
    status          VARCHAR(20) DEFAULT 'pending',  -- pending, verified, expired, failed

    expires_at      TIMESTAMP WITH TIME ZONE,
    verified_at     TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_verification_requests IS 'Identity/credential verification requests';
