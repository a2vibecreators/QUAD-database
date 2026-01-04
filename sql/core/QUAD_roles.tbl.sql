-- QUAD_roles Table
-- Domain-specific roles (Management, Developer, QA, Infrastructure)
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_roles (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id               UUID NOT NULL,  -- References quad_domains
    core_role_id            UUID,           -- Reference to base role template
    name                    VARCHAR(255) NOT NULL,
    description             VARCHAR(255),
    responsibilities_text   TEXT,
    is_custom               BOOLEAN DEFAULT false,
    is_active               BOOLEAN DEFAULT true,
    created_at              TIMESTAMP DEFAULT NOW(),
    updated_at              TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_roles_domain ON quad_roles(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_roles_name ON quad_roles(name);

-- Comments
COMMENT ON TABLE quad_roles IS 'Domain-specific roles with responsibilities';
