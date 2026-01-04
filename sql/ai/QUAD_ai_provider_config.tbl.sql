-- QUAD_ai_provider_config Table
-- AI provider configuration and API keys
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_provider_config (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    provider        VARCHAR(20) NOT NULL,  -- claude, gemini, openai, groq, deepseek
    api_key_vault_path VARCHAR(255),

    default_model   VARCHAR(100),
    max_tokens      INTEGER DEFAULT 4096,
    temperature     NUMERIC(3,2) DEFAULT 0.7,

    is_enabled      BOOLEAN DEFAULT true,
    priority        INTEGER DEFAULT 50,  -- For fallback ordering

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_provider_config IS 'AI provider configuration and API keys';
