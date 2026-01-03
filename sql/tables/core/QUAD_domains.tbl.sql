-- Table: QUAD_domains
-- Section: core
-- Purpose: Organizational domains (projects, teams, business areas)

CREATE TABLE QUAD_domains (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES QUAD_companies(id) ON DELETE CASCADE,

    -- Domain identification
    name VARCHAR(255) NOT NULL,

    -- Hierarchy (self-referential)
    parent_domain_id UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    -- Classification
    domain_type VARCHAR(50),
    -- 'project', 'team', 'department', 'product', 'feature'

    -- Path for hierarchical queries (materialized path pattern)
    path TEXT,
    -- Example: '/Engineering/Backend/Auth'

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_quad_domains_company ON QUAD_domains(company_id);
CREATE INDEX idx_quad_domains_parent ON QUAD_domains(parent_domain_id);
CREATE INDEX idx_quad_domains_type ON QUAD_domains(domain_type);
CREATE INDEX idx_quad_domains_path ON QUAD_domains(path);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_domains_updated_at
    BEFORE UPDATE ON QUAD_domains
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_domains IS 'Organizational domains. Supports hierarchy for projects within departments.';
COMMENT ON COLUMN QUAD_domains.path IS 'Materialized path for efficient hierarchical queries.';
