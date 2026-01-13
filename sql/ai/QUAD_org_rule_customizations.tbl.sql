-- QUAD_org_rule_customizations Table
-- Organization-specific coding rule overrides and additions
--
-- Purpose:
-- Store org-specific rule customizations that override industry defaults
-- Each organization can add their own DO's and DON'Ts on top of industry standards
--
-- Example Use Cases:
-- - MassMutual (investment_banking): Add "Use MMLogger instead of Log4j"
-- - HealthFirst (healthcare): Add "Use internal PHI encryption library"
-- - ShopNow (ecommerce): Add "Use company's payment gateway wrapper"
--
-- Integration with QUAD Flow:
-- - Links to quad_organizations (per-org customization)
-- - Can optionally link to quad_domains (domain-specific rules)
-- - Works with existing QUAD flow structure
--
-- Part of: QUAD AI Agent Rules System
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_org_rule_customizations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Organization scope
    org_id          UUID NOT NULL REFERENCES quad_organizations(id) ON DELETE CASCADE,

    -- Optional domain scope (NULL = applies to all domains in org)
    domain_id       UUID REFERENCES quad_domains(id) ON DELETE CASCADE,

    -- Activity targeting
    activity_type   VARCHAR(100) NOT NULL,      -- Same as industry_defaults

    -- Rule definition
    rule_type       VARCHAR(20) NOT NULL,       -- 'DO' or 'DONT'
    rule_text       TEXT NOT NULL,              -- Human-readable rule

    -- Priority (org rules override industry defaults)
    priority        INT DEFAULT 300,            -- Org customizations: 300 (higher than industry 100)

    -- Rule management
    is_active       BOOLEAN DEFAULT true,
    is_override     BOOLEAN DEFAULT false,      -- true = replaces industry rule, false = adds to it

    -- Metadata
    created_by      UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    updated_by      UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_org_customizations_org
    ON quad_org_rule_customizations(org_id)
    WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_quad_org_customizations_domain
    ON quad_org_rule_customizations(domain_id)
    WHERE domain_id IS NOT NULL AND is_active = true;

CREATE INDEX IF NOT EXISTS idx_quad_org_customizations_lookup
    ON quad_org_rule_customizations(org_id, activity_type, rule_type)
    WHERE is_active = true;

-- Constraints
ALTER TABLE quad_org_rule_customizations
    ADD CONSTRAINT chk_org_customizations_rule_type
    CHECK (rule_type IN ('DO', 'DONT'));

-- Comments
COMMENT ON TABLE quad_org_rule_customizations IS 'Organization-specific coding rule overrides and additions';
COMMENT ON COLUMN quad_org_rule_customizations.org_id IS 'Organization this rule applies to';
COMMENT ON COLUMN quad_org_rule_customizations.domain_id IS 'Optional: Domain-specific rule (NULL = applies to all domains)';
COMMENT ON COLUMN quad_org_rule_customizations.is_override IS 'true = replaces industry rule, false = adds to it';
COMMENT ON COLUMN quad_org_rule_customizations.priority IS 'Higher than industry defaults (300 > 100)';
