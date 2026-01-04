-- QUAD_dora_metrics Table
-- DORA metrics tracking
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_dora_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    period_start DATE NOT NULL, period_end DATE NOT NULL,
    deployment_frequency NUMERIC(10,2), lead_time_hours NUMERIC(10,2),
    change_failure_rate NUMERIC(5,2), mttr_hours NUMERIC(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(domain_id, period_start)
);
COMMENT ON TABLE QUAD_dora_metrics IS 'DORA metrics tracking';
