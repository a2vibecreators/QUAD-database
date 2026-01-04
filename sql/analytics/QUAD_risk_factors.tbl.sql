-- QUAD_risk_factors Table
-- Project risk factors
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_risk_factors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    risk_type VARCHAR(50) NOT NULL, description TEXT,
    severity VARCHAR(20) DEFAULT 'medium', probability VARCHAR(20) DEFAULT 'medium',
    mitigation_plan TEXT, status VARCHAR(20) DEFAULT 'open',
    identified_by UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_risk_factors IS 'Project risk factors';
