-- QUAD_secret_scans Table
-- Secret scanning results
-- Part of: QUAD Security | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_secret_scans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    scan_type VARCHAR(50) NOT NULL, status VARCHAR(20) DEFAULT 'completed',
    secrets_found INTEGER DEFAULT 0, files_scanned INTEGER DEFAULT 0,
    findings JSONB, started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_secret_scans IS 'Secret scanning results';
