-- Table: QUAD_domain_resources
-- Section: core
-- Purpose: Resources within domains (EAV pattern for flexibility)

CREATE TABLE QUAD_domain_resources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    -- Resource identification
    resource_type VARCHAR(50) NOT NULL,
    -- 'repository', 'database', 'api', 'service', 'documentation', 'tool'

    resource_name VARCHAR(255) NOT NULL,

    -- Status
    resource_status VARCHAR(50) DEFAULT 'pending_setup',
    -- 'pending_setup', 'active', 'deprecated', 'archived'

    -- Audit
    created_by UUID REFERENCES QUAD_users(id),

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_quad_domain_resources_domain ON QUAD_domain_resources(domain_id);
CREATE INDEX idx_quad_domain_resources_type ON QUAD_domain_resources(resource_type);
CREATE INDEX idx_quad_domain_resources_status ON QUAD_domain_resources(resource_status);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_domain_resources_updated_at
    BEFORE UPDATE ON QUAD_domain_resources
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_domain_resources IS 'Domain resources using EAV pattern. Attributes stored in QUAD_resource_attributes.';
