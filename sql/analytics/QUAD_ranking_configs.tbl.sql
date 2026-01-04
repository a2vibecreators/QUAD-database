-- QUAD_ranking_configs Table
-- User ranking configurations
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ranking_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL, weights JSONB NOT NULL,
    is_default BOOLEAN DEFAULT false, is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_ranking_configs IS 'User ranking configurations';
