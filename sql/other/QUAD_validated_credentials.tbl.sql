-- QUAD_validated_credentials Table
-- Verified user credentials
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_validated_credentials (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    credential_type VARCHAR(50) NOT NULL,  -- github, linkedin, email_domain
    credential_value VARCHAR(255) NOT NULL,

    verified_at     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at      TIMESTAMP WITH TIME ZONE,

    metadata        JSONB,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(user_id, credential_type)
);

COMMENT ON TABLE QUAD_validated_credentials IS 'Verified user credentials';
