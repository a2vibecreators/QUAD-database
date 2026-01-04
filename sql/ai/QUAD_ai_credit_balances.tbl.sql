-- QUAD_ai_credit_balances Table
-- AI credit balances per organization
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_credit_balances (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    balance_usd     NUMERIC(10,2) DEFAULT 0,
    monthly_budget  NUMERIC(10,2),
    monthly_used    NUMERIC(10,2) DEFAULT 0,
    period_start    DATE,

    alert_threshold_pct INTEGER DEFAULT 80,
    last_alert_at   TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(org_id)
);

COMMENT ON TABLE QUAD_ai_credit_balances IS 'AI credit balances per organization';
