/**
 * Suma API - Test Companies Seed Data
 *
 * Creates 3 test companies with API keys and prepaid credits for testing
 *
 * Test Companies:
 * 1. NutriNine (Internal) - Health app company
 * 2. A2Vibe Creators (Internal) - Our own company website
 * 3. TestCorp Ltd (External) - Mock external customer
 *
 * @author Gopi Addanke
 * @since January 9, 2026
 */

-- First, verify QUAD_companies table exists (dependency)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'quad_companies') THEN
        RAISE EXCEPTION 'QUAD_companies table does not exist. Please create it first.';
    END IF;
END $$;

-- ==============================================================================
-- 1. NutriNine (Internal Test Company)
-- ==============================================================================

-- Insert company (if not exists)
INSERT INTO QUAD_companies (id, name, admin_email, size, created_at, updated_at)
VALUES (
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890'::uuid,
    'NutriNine Health',
    'admin@nutrinine.com',
    'medium',
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- Insert prepaid credits (10,000 tokens = $80 worth)
INSERT INTO QUAD_suma_credits (id, company_id, balance_tokens, total_purchased, total_used, lifetime_spend_usd, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890'::uuid,
    10000,  -- 10K tokens remaining
    10000,  -- 10K tokens purchased
    0,      -- 0 tokens used
    80.00,  -- $80 spent
    NOW(),
    NOW()
) ON CONFLICT (company_id) DO NOTHING;

-- Insert API key (sk_test_... for sandbox testing)
INSERT INTO QUAD_suma_api_keys (
    id, company_id, api_key, api_secret_hash, name, environment,
    rate_limit_per_minute, rate_limit_per_day, allowed_domains, is_active, created_at, last_used_at
) VALUES (
    gen_random_uuid(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890'::uuid,
    'sk_test_nutrinine_dev_1234567890abcdef',
    '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL.JNkOa',  -- bcrypt hash of 'test_secret'
    'NutriNine DEV Key',
    'sandbox',
    60,     -- 60 requests/minute
    10000,  -- 10,000 requests/day
    ARRAY['dev.nutrinine.com', 'localhost:3000'],
    true,
    NOW(),
    NULL
) ON CONFLICT (api_key) DO NOTHING;

-- ==============================================================================
-- 2. A2Vibe Creators (Internal Test Company)
-- ==============================================================================

-- Insert company (if not exists)
INSERT INTO QUAD_companies (id, name, admin_email, size, created_at, updated_at)
VALUES (
    'b2c3d4e5-f6a7-8901-bcde-f12345678901'::uuid,
    'A2Vibe Creators',
    'admin@a2vibecreators.com',
    'large',
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- Insert prepaid credits (50,000 tokens = $400 worth)
INSERT INTO QUAD_suma_credits (id, company_id, balance_tokens, total_purchased, total_used, lifetime_spend_usd, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'b2c3d4e5-f6a7-8901-bcde-f12345678901'::uuid,
    50000,  -- 50K tokens remaining
    50000,  -- 50K tokens purchased
    0,      -- 0 tokens used
    400.00, -- $400 spent
    NOW(),
    NOW()
) ON CONFLICT (company_id) DO NOTHING;

-- Insert API key (sk_test_... for sandbox testing)
INSERT INTO QUAD_suma_api_keys (
    id, company_id, api_key, api_secret_hash, name, environment,
    rate_limit_per_minute, rate_limit_per_day, allowed_domains, is_active, created_at, last_used_at
) VALUES (
    gen_random_uuid(),
    'b2c3d4e5-f6a7-8901-bcde-f12345678901'::uuid,
    'sk_test_a2vibe_dev_abcdef1234567890',
    '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL.JNkOa',  -- bcrypt hash of 'test_secret'
    'A2Vibe DEV Key',
    'sandbox',
    120,    -- 120 requests/minute (enterprise tier)
    50000,  -- 50,000 requests/day
    ARRAY['dev.a2vibecreators.com', 'localhost:3000'],
    true,
    NOW(),
    NULL
) ON CONFLICT (api_key) DO NOTHING;

-- ==============================================================================
-- 3. TestCorp Ltd (External Mock Customer)
-- ==============================================================================

-- Insert company (if not exists)
INSERT INTO QUAD_companies (id, name, admin_email, size, created_at, updated_at)
VALUES (
    'c3d4e5f6-a7b8-9012-cdef-123456789012'::uuid,
    'TestCorp Ltd',
    'admin@testcorp.example.com',
    'small',
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- Insert prepaid credits (500 tokens = $4 worth - free tier trial)
INSERT INTO QUAD_suma_credits (id, company_id, balance_tokens, total_purchased, total_used, lifetime_spend_usd, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'c3d4e5f6-a7b8-9012-cdef-123456789012'::uuid,
    500,    -- 500 tokens remaining (free trial)
    500,    -- 500 tokens given
    0,      -- 0 tokens used
    0.00,   -- $0 spent (free trial)
    NOW(),
    NOW()
) ON CONFLICT (company_id) DO NOTHING;

-- Insert API key (sk_test_... for sandbox testing)
INSERT INTO QUAD_suma_api_keys (
    id, company_id, api_key, api_secret_hash, name, environment,
    rate_limit_per_minute, rate_limit_per_day, allowed_domains, is_active, created_at, last_used_at
) VALUES (
    gen_random_uuid(),
    'c3d4e5f6-a7b8-9012-cdef-123456789012'::uuid,
    'sk_test_testcorp_trial_1234567890ab',
    '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL.JNkOa',  -- bcrypt hash of 'test_secret'
    'TestCorp Trial Key',
    'sandbox',
    10,     -- 10 requests/minute (free tier limit)
    1000,   -- 1,000 requests/day (free tier limit)
    NULL,   -- No domain restrictions
    true,
    NOW(),
    NULL
) ON CONFLICT (api_key) DO NOTHING;

-- ==============================================================================
-- Verification Queries
-- ==============================================================================

-- Show all test companies
SELECT
    c.name as company,
    c.admin_email,
    c.size,
    cr.balance_tokens,
    cr.total_purchased,
    cr.lifetime_spend_usd,
    k.api_key,
    k.name as api_key_name,
    k.rate_limit_per_minute,
    k.rate_limit_per_day
FROM QUAD_companies c
LEFT JOIN QUAD_suma_credits cr ON c.id = cr.company_id
LEFT JOIN QUAD_suma_api_keys k ON c.id = k.company_id
WHERE c.name IN ('NutriNine Health', 'A2Vibe Creators', 'TestCorp Ltd')
ORDER BY c.size DESC;

/**
 * Usage Instructions:
 *
 * 1. Deploy to DEV database:
 *    docker cp quad-database/sql/seeds/suma_api_test_companies.sql postgres-quad-dev:/tmp/
 *    docker exec postgres-quad-dev psql -U quad_user -d quad_dev_db -f /tmp/suma_api_test_companies.sql
 *
 * 2. Test API keys:
 *    curl -X POST https://dev-api.asksuma.ai/v1/chat \
 *      -H "X-API-Key: sk_test_nutrinine_dev_1234567890abcdef" \
 *      -H "Content-Type: application/json" \
 *      -d '{"messages": [{"role": "user", "content": "Hello"}]}'
 *
 * 3. Verify credits were deducted:
 *    SELECT company_id, balance_tokens, total_used FROM QUAD_suma_credits;
 *
 * Note: API secret hash is bcrypt('test_secret') for all test keys
 */
