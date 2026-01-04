-- QUAD_domains Table
-- Organizational units (projects/products)
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_domains (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id          UUID NOT NULL REFERENCES quad_companies(id) ON DELETE CASCADE,
    name                VARCHAR(255) NOT NULL,
    slug                VARCHAR(255),
    description         VARCHAR(255),
    methodology         VARCHAR(255),  -- scrum, kanban, quad
    git_repo_url        VARCHAR(255),
    git_default_branch  VARCHAR(255) DEFAULT 'main',
    created_by          UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    is_active           BOOLEAN DEFAULT true,
    is_deleted          BOOLEAN DEFAULT false,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_domains_company ON quad_domains(company_id);
CREATE INDEX IF NOT EXISTS idx_quad_domains_slug ON quad_domains(slug);
CREATE INDEX IF NOT EXISTS idx_quad_domains_name ON quad_domains(name);

-- Comments
COMMENT ON TABLE quad_domains IS 'Organizational units (hierarchical). Root domain: parent_domain_id = NULL';
