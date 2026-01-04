-- QUAD_resource_attribute_requirements Table
-- Defines which attributes are required for which resource types
--
-- Part of: QUAD Domains
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_resource_attribute_requirements (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    resource_type   VARCHAR(50) NOT NULL,
    attribute_name  VARCHAR(50) NOT NULL,
    is_required     BOOLEAN DEFAULT false,
    display_order   INTEGER,
    validation_rule VARCHAR(50),  -- url, email, alphanumeric, etc.
    allowed_values  TEXT[],
    help_text       TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),

    UNIQUE(resource_type, attribute_name)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_resource_attr_req_type ON quad_resource_attribute_requirements(resource_type);

-- Comments
COMMENT ON TABLE quad_resource_attribute_requirements IS 'Defines which attributes are required for which resource types. Controls form validation and display order.';
