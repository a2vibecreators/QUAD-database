-- QUAD_resource_attributes Table
-- Key-value attributes for resources (EAV pattern)
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_resource_attributes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resource_id     UUID NOT NULL REFERENCES quad_domain_resources(id) ON DELETE CASCADE,
    attribute_name  VARCHAR(50) NOT NULL,
    attribute_value TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),

    UNIQUE(resource_id, attribute_name)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_resource_attributes_resource ON quad_resource_attributes(resource_id);
CREATE INDEX IF NOT EXISTS idx_quad_resource_attributes_name ON quad_resource_attributes(attribute_name);

-- Comments
COMMENT ON TABLE quad_resource_attributes IS 'Key-value attributes for resources. Stores blueprint URLs, tech stack, Git repos, etc. as rows (not columns).';
