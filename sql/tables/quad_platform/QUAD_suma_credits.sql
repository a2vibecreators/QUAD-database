-- Suma API - Prepaid Credits Balance
-- Purpose: Track prepaid token balance for Suma API customers
-- Created: January 9, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_credits (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign key (one record per organization)
    org_id UUID NOT NULL UNIQUE REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    -- Token balance (prepaid)
    balance_tokens BIGINT DEFAULT 0 CHECK (balance_tokens >= 0),

    -- Lifetime statistics
    total_purchased BIGINT DEFAULT 0 CHECK (total_purchased >= 0),
    total_used BIGINT DEFAULT 0 CHECK (total_used >= 0),
    lifetime_spend_usd DECIMAL(10, 2) DEFAULT 0.00 CHECK (lifetime_spend_usd >= 0),

    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_suma_credits_org ON QUAD_suma_credits(org_id);
CREATE INDEX idx_suma_credits_balance ON QUAD_suma_credits(balance_tokens) WHERE balance_tokens > 0;

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_suma_credits_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_suma_credits_updated_at
    BEFORE UPDATE ON QUAD_suma_credits
    FOR EACH ROW
    EXECUTE FUNCTION update_suma_credits_timestamp();

-- Comments
COMMENT ON TABLE QUAD_suma_credits IS 'Prepaid token credits for Suma API customers';
COMMENT ON COLUMN QUAD_suma_credits.balance_tokens IS 'Current prepaid token balance';
COMMENT ON COLUMN QUAD_suma_credits.total_purchased IS 'Lifetime tokens purchased';
COMMENT ON COLUMN QUAD_suma_credits.total_used IS 'Lifetime tokens consumed';
COMMENT ON COLUMN QUAD_suma_credits.lifetime_spend_usd IS 'Total amount spent in USD';
