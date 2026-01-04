-- QUAD_api_access_config Table
-- API access configuration
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_api_access_config (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    api_key_hash    VARCHAR(64) NOT NULL UNIQUE,
    api_key_prefix  VARCHAR(10),  -- First 8 chars for identification

    name            VARCHAR(100) NOT NULL,
    description     TEXT,
    scopes          TEXT[],

    rate_limit_per_minute INTEGER DEFAULT 60,
    rate_limit_per_day INTEGER DEFAULT 10000,

    is_active       BOOLEAN DEFAULT true,
    expires_at      TIMESTAMP WITH TIME ZONE,
    last_used_at    TIMESTAMP WITH TIME ZONE,

    created_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_api_access_config IS 'API access configuration';
