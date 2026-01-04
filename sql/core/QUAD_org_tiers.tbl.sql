-- QUAD_org_tiers Table
-- Organization tier definitions (pricing/feature levels)
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_org_tiers (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(50) NOT NULL UNIQUE,  -- free, starter, professional, enterprise
    display_name    VARCHAR(100) NOT NULL,
    description     TEXT,

    -- Limits
    max_users       INTEGER,
    max_domains     INTEGER,
    max_ai_requests_month INTEGER,
    max_storage_gb  INTEGER,

    -- Features
    features        JSONB DEFAULT '{}',

    -- Pricing
    price_monthly   NUMERIC(10,2),
    price_yearly    NUMERIC(10,2),

    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Comments
COMMENT ON TABLE QUAD_org_tiers IS 'Organization tier definitions (pricing/feature levels)';
