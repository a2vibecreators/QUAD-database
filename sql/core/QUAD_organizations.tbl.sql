-- quad_organizations Table
-- Core organization/company entity (matches Java Organization.java entity)
--
-- Part of: QUAD Core
-- Created: January 2026
-- Last Modified: January 6, 2026

CREATE TABLE IF NOT EXISTS quad_organizations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(255) NOT NULL,
    slug            VARCHAR(100) UNIQUE,
    contact_email   VARCHAR(255),
    billing_email   VARCHAR(255),
    contact_phone   VARCHAR(255),
    website         VARCHAR(255),
    industry        VARCHAR(255),
    team_size       VARCHAR(50),
    timezone        VARCHAR(255),
    logo_url        VARCHAR(255),
    ai_tier         VARCHAR(50),
    sandbox_strategy VARCHAR(50),
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_organizations_slug ON quad_organizations(slug);
CREATE INDEX IF NOT EXISTS idx_quad_organizations_contact_email ON quad_organizations(contact_email);

-- Comments
COMMENT ON TABLE quad_organizations IS 'Core organization/company accounts';
COMMENT ON COLUMN quad_organizations.slug IS 'Unique URL-safe identifier';
COMMENT ON COLUMN quad_organizations.ai_tier IS 'AI pricing tier (turbo/balanced/quality/byok)';
COMMENT ON COLUMN quad_organizations.sandbox_strategy IS 'Sandbox isolation strategy';
