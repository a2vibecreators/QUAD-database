-- QUAD_domain_members Table
-- User membership in domains with roles
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_domain_members (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                 UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,
    domain_id               UUID NOT NULL REFERENCES quad_domains(id) ON DELETE CASCADE,
    role                    VARCHAR(50) NOT NULL,  -- MANAGER, DEVELOPER, QA, INFRASTRUCTURE
    allocation_percentage   INTEGER DEFAULT 100,
    created_at              TIMESTAMP DEFAULT NOW(),
    updated_at              TIMESTAMP DEFAULT NOW(),

    UNIQUE(user_id, domain_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_domain_members_user ON quad_domain_members(user_id);
CREATE INDEX IF NOT EXISTS idx_quad_domain_members_domain ON quad_domain_members(domain_id);
CREATE INDEX IF NOT EXISTS idx_quad_domain_members_role ON quad_domain_members(role);

-- Comments
COMMENT ON TABLE quad_domain_members IS 'User membership in domains with roles. One user can have different roles in different domains.';
COMMENT ON COLUMN quad_domain_members.allocation_percentage IS 'Percentage of time user works on this domain (must total <= 100% across all domains)';
