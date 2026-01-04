-- QUAD_ai_configs Table
-- AI configuration per org/domain/user
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_configs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- Provider preferences
    preferred_provider VARCHAR(20) DEFAULT 'claude',
    tier            VARCHAR(20) DEFAULT 'balanced',  -- turbo, balanced, quality

    -- Feature toggles
    enable_code_review BOOLEAN DEFAULT true,
    enable_estimation BOOLEAN DEFAULT true,
    enable_suggestions BOOLEAN DEFAULT true,

    -- Limits
    daily_request_limit INTEGER,
    monthly_token_limit INTEGER,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_configs IS 'AI configuration per org/domain/user';
