-- QUAD_runbook_executions Table
-- Runbook execution history
-- Part of: QUAD Security | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_runbook_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    runbook_id UUID NOT NULL REFERENCES QUAD_incident_runbooks(id) ON DELETE CASCADE,
    triggered_by UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    incident_description TEXT, status VARCHAR(20) DEFAULT 'in_progress',
    steps_completed JSONB, started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE, resolution_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_runbook_executions IS 'Runbook execution history';
