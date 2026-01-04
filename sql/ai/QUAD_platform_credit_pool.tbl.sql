-- QUAD_platform_credit_pool Table
-- Platform-wide AI credit pool
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_platform_credit_pool (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    provider        VARCHAR(20) NOT NULL,
    total_credits   NUMERIC(12,2) DEFAULT 0,
    used_credits    NUMERIC(12,2) DEFAULT 0,
    reserved_credits NUMERIC(12,2) DEFAULT 0,

    alert_threshold_pct INTEGER DEFAULT 80,
    last_refill_at  TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(provider)
);

COMMENT ON TABLE QUAD_platform_credit_pool IS 'Platform-wide AI credit pool';
