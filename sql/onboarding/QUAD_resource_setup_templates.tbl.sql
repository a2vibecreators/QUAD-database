-- QUAD_resource_setup_templates Table
-- Resource setup templates
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_resource_setup_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL, resource_type VARCHAR(50) NOT NULL,
    description TEXT, steps JSONB NOT NULL,
    estimated_minutes INTEGER, is_system BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_resource_setup_templates IS 'Resource setup templates';
