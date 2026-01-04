-- ============================================================================
-- QUAD Framework - AI Provider Configuration Seed Data
-- ============================================================================
-- File: 003_ai_providers.dta.sql
-- Purpose: System default AI provider configurations for QUAD Framework
--
-- These are system-level defaults (org_id = NULL) that apply to all orgs
-- unless overridden. Organizations can create their own configs with
-- specific API keys and settings.
--
-- Provider Priority (lower = higher priority):
--   10 = Claude (primary for code analysis)
--   20 = Gemini (secondary, good for general tasks)
--   30 = OpenAI (tertiary, GPT-4 Turbo)
--   40 = DeepSeek (specialized for code generation)
--
-- Note: api_key_vault_path should be configured per-org in production
-- ============================================================================

-- Clear existing system defaults before inserting
DELETE FROM QUAD_ai_provider_config WHERE org_id IS NULL;

-- Claude (Anthropic) - Primary Provider
INSERT INTO QUAD_ai_provider_config (
    id, org_id, provider, api_key_vault_path, default_model,
    max_tokens, temperature, is_enabled, priority, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000001',
    NULL,  -- System default
    'claude',
    'secrets/ai/claude/api-key',
    'claude-3-5-sonnet-20241022',
    8192,
    0.70,
    true,
    10,  -- Highest priority
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Gemini (Google) - Secondary Provider
INSERT INTO QUAD_ai_provider_config (
    id, org_id, provider, api_key_vault_path, default_model,
    max_tokens, temperature, is_enabled, priority, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000002',
    NULL,  -- System default
    'gemini',
    'secrets/ai/gemini/api-key',
    'gemini-1.5-pro',
    8192,
    0.70,
    true,
    20,  -- Second priority
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- OpenAI - Tertiary Provider
INSERT INTO QUAD_ai_provider_config (
    id, org_id, provider, api_key_vault_path, default_model,
    max_tokens, temperature, is_enabled, priority, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000003',
    NULL,  -- System default
    'openai',
    'secrets/ai/openai/api-key',
    'gpt-4-turbo',
    4096,
    0.70,
    true,
    30,  -- Third priority
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- DeepSeek - Specialized Code Provider
INSERT INTO QUAD_ai_provider_config (
    id, org_id, provider, api_key_vault_path, default_model,
    max_tokens, temperature, is_enabled, priority, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0003-000000000004',
    NULL,  -- System default
    'deepseek',
    'secrets/ai/deepseek/api-key',
    'deepseek-coder',
    16384,
    0.70,
    true,
    40,  -- Fourth priority (specialized use)
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- ============================================================================
-- End of AI Provider Seed Data
-- ============================================================================
