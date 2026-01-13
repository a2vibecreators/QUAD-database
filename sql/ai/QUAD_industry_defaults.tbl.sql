-- QUAD_industry_defaults Table
-- Industry-standard coding rules (DO's and DON'Ts) that guide AI code generation
--
-- Purpose:
-- Store default coding rules per industry (investment_banking, healthcare, ecommerce, etc.)
-- These are the baseline rules that apply to all organizations in an industry
-- Organizations can override these with QUAD_org_rule_customizations
--
-- Integration with QUAD Flow:
-- - Rules are per activity_type (add_api_endpoint, create_ui_screen, etc.)
-- - AI agents read these rules before generating code
-- - Works with existing QUAD_domains (web, database, payment systems)
-- - Works with existing QUAD_circles (4 circles: management, development, QA, infrastructure)
--
-- Part of: QUAD AI Agent Rules System
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_industry_defaults (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Industry classification
    industry        VARCHAR(100) NOT NULL,      -- 'investment_banking', 'healthcare', 'ecommerce', etc.

    -- Activity targeting
    activity_type   VARCHAR(100) NOT NULL,      -- 'add_api_endpoint', 'create_ui_screen', 'add_database_table', etc.

    -- Rule definition
    rule_type       VARCHAR(20) NOT NULL,       -- 'DO' or 'DONT'
    rule_text       TEXT NOT NULL,              -- Human-readable rule (e.g., 'Use Java Spring Boot')

    -- Priority (for conflict resolution)
    priority        INT DEFAULT 100,            -- Industry defaults: 100, Org customizations: 300

    -- Metadata
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_industry_defaults_industry
    ON quad_industry_defaults(industry);

CREATE INDEX IF NOT EXISTS idx_quad_industry_defaults_activity
    ON quad_industry_defaults(activity_type);

CREATE INDEX IF NOT EXISTS idx_quad_industry_defaults_lookup
    ON quad_industry_defaults(industry, activity_type, rule_type);

-- Constraints
ALTER TABLE quad_industry_defaults
    ADD CONSTRAINT chk_industry_defaults_rule_type
    CHECK (rule_type IN ('DO', 'DONT'));

-- Comments
COMMENT ON TABLE quad_industry_defaults IS 'Industry-standard coding rules that guide AI code generation';
COMMENT ON COLUMN quad_industry_defaults.industry IS 'Industry classification (investment_banking, healthcare, ecommerce)';
COMMENT ON COLUMN quad_industry_defaults.activity_type IS 'Development activity (add_api_endpoint, create_ui_screen, etc.)';
COMMENT ON COLUMN quad_industry_defaults.rule_type IS 'DO (best practice) or DONT (avoid)';
COMMENT ON COLUMN quad_industry_defaults.priority IS 'Higher priority rules override lower (100=industry default, 300=org custom)';
