-- QUAD_companies Table
-- Top-level customer organizations (A2Vibe Creators, MassMutual, etc.)
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_companies (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(255) NOT NULL,
    admin_email     VARCHAR(255) NOT NULL,
    size            VARCHAR(50) DEFAULT 'medium',  -- small, medium, large, enterprise
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_companies_name ON quad_companies(name);
CREATE INDEX IF NOT EXISTS idx_quad_companies_admin_email ON quad_companies(admin_email);

-- Comments
COMMENT ON TABLE quad_companies IS 'Top-level customer organizations (A2Vibe Creators, MassMutual, etc.)';
COMMENT ON COLUMN quad_companies.size IS 'Company size: small (1-10), medium (11-50), large (51-200), enterprise (200+)';
