-- QUAD_developer_onboarding_templates Table
-- Developer-specific onboarding templates
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_developer_onboarding_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL, tech_stack TEXT[],
    prerequisites JSONB, setup_steps JSONB NOT NULL,
    estimated_hours INTEGER, is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_developer_onboarding_templates IS 'Developer-specific onboarding templates';
