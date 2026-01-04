-- QUAD_ai_credit_transactions Table
-- AI credit usage transactions
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_credit_transactions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    transaction_type VARCHAR(20) NOT NULL,  -- usage, credit, refund, adjustment
    amount_usd      NUMERIC(10,6) NOT NULL,

    description     VARCHAR(255),
    operation_id    UUID,  -- Reference to QUAD_ai_operations

    balance_after   NUMERIC(10,2),

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_credit_transactions IS 'AI credit usage transactions';
