-- Suma API - API Keys Management
-- Purpose: Store API keys for third-party customers using Suma API (api.suma.ai)
-- Created: January 9, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_api_keys (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign keys
    org_id UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    created_by UUID REFERENCES QUAD_users(id),

    -- API key details
    api_key VARCHAR(64) UNIQUE NOT NULL, -- "sk_live_abc123..." or "sk_test_xyz789..."
    api_secret_hash VARCHAR(128) NOT NULL, -- bcrypt hashed secret

    -- Metadata
    name VARCHAR(200) NOT NULL, -- "Production API Key", "Development Key"
    environment VARCHAR(20) NOT NULL CHECK (environment IN ('production', 'sandbox')),

    -- Rate limiting
    rate_limit_per_minute INT DEFAULT 60 CHECK (rate_limit_per_minute > 0),
    rate_limit_per_day INT DEFAULT 10000 CHECK (rate_limit_per_day > 0),

    -- Security
    allowed_domains TEXT[], -- ["example.com", "*.example.com"] - CORS whitelist
    is_active BOOLEAN DEFAULT true,

    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    last_used_at TIMESTAMP,
    expires_at TIMESTAMP -- Optional expiration date
);

-- Indexes for performance
CREATE INDEX idx_suma_api_keys_api_key ON QUAD_suma_api_keys(api_key) WHERE is_active = true;
CREATE INDEX idx_suma_api_keys_org ON QUAD_suma_api_keys(org_id);
CREATE INDEX idx_suma_api_keys_environment ON QUAD_suma_api_keys(environment);

-- Comments
COMMENT ON TABLE QUAD_suma_api_keys IS 'Suma API keys for third-party customers (api.suma.ai)';
COMMENT ON COLUMN QUAD_suma_api_keys.api_key IS 'Public API key (sk_live_... or sk_test_...)';
COMMENT ON COLUMN QUAD_suma_api_keys.api_secret_hash IS 'Bcrypt hashed secret for verification';
COMMENT ON COLUMN QUAD_suma_api_keys.allowed_domains IS 'CORS whitelist - domains allowed to call API';
COMMENT ON COLUMN QUAD_suma_api_keys.rate_limit_per_minute IS 'Max requests per minute per API key';
COMMENT ON COLUMN QUAD_suma_api_keys.rate_limit_per_day IS 'Max requests per day per API key';
