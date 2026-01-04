-- QUAD_setup_bundles Table
-- Bundled setup packages
-- Part of: QUAD Onboarding | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_setup_bundles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL, description TEXT,
    template_ids UUID[] NOT NULL, target_role VARCHAR(50),
    estimated_minutes INTEGER, is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_setup_bundles IS 'Bundled setup packages';
