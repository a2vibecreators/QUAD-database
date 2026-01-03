-- Table: QUAD_resource_attributes
-- Section: core
-- Purpose: Flexible attributes for domain resources (EAV pattern)

CREATE TABLE QUAD_resource_attributes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resource_id UUID NOT NULL REFERENCES QUAD_domain_resources(id) ON DELETE CASCADE,

    -- Attribute key-value
    attribute_name VARCHAR(50) NOT NULL,
    attribute_value TEXT,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    UNIQUE(resource_id, attribute_name)
);

-- Indexes
CREATE INDEX idx_quad_resource_attributes_resource ON QUAD_resource_attributes(resource_id);
CREATE INDEX idx_quad_resource_attributes_name ON QUAD_resource_attributes(attribute_name);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_resource_attributes_updated_at
    BEFORE UPDATE ON QUAD_resource_attributes
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_resource_attributes IS 'EAV attributes for domain resources. Allows flexible schema per resource type.';
COMMENT ON COLUMN QUAD_resource_attributes.attribute_name IS 'Examples: url, connection_string, api_key_vault_path, port, environment';
