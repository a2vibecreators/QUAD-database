-- Table: QUAD_companies
-- Section: core
-- Purpose: Multi-tenant company/organization management

CREATE TABLE QUAD_companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Company identification
    name VARCHAR(255) NOT NULL,
    admin_email VARCHAR(255) UNIQUE NOT NULL,

    -- Company size for recommendations
    size VARCHAR(50) DEFAULT 'medium',
    -- 'startup' (1-10), 'small' (11-50), 'medium' (51-200), 'large' (201+)

    -- Status
    is_active BOOLEAN DEFAULT TRUE,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_quad_companies_email ON QUAD_companies(admin_email);
CREATE INDEX idx_quad_companies_active ON QUAD_companies(is_active) WHERE is_active = TRUE;

-- Trigger for updated_at
CREATE TRIGGER trg_quad_companies_updated_at
    BEFORE UPDATE ON QUAD_companies
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_companies IS 'Multi-tenant company/organization. Each company has its own users, domains, and settings.';
