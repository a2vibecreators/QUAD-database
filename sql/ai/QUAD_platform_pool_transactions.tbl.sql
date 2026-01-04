-- QUAD_platform_pool_transactions Table
-- Platform credit pool transactions
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_platform_pool_transactions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pool_id         UUID NOT NULL REFERENCES QUAD_platform_credit_pool(id) ON DELETE CASCADE,
    org_id          UUID REFERENCES QUAD_organizations(id) ON DELETE SET NULL,

    transaction_type VARCHAR(20) NOT NULL,  -- refill, usage, reservation, release
    amount          NUMERIC(10,6) NOT NULL,
    description     VARCHAR(255),

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_platform_pool_transactions IS 'Platform credit pool transactions';
