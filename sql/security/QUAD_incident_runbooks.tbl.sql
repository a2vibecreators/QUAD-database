-- QUAD_incident_runbooks Table
-- Incident response runbooks
-- Part of: QUAD Security | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_incident_runbooks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL, incident_type VARCHAR(50) NOT NULL,
    description TEXT, steps JSONB NOT NULL,
    escalation_contacts JSONB, is_active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_incident_runbooks IS 'Incident response runbooks';
