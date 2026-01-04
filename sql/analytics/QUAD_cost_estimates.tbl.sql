-- QUAD_cost_estimates Table
-- Project cost estimates
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_cost_estimates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    estimate_date DATE NOT NULL,
    estimated_hours NUMERIC(10,2), hourly_rate NUMERIC(10,2),
    total_cost NUMERIC(12,2), confidence_level NUMERIC(3,2),
    assumptions JSONB, created_by UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_cost_estimates IS 'Project cost estimates';
