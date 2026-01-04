-- QUAD_technical_debt_scores Table
-- Technical debt tracking
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_technical_debt_scores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    score_date DATE NOT NULL, overall_score NUMERIC(5,2),
    code_quality_score NUMERIC(5,2), test_coverage_score NUMERIC(5,2),
    documentation_score NUMERIC(5,2), dependency_score NUMERIC(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(domain_id, score_date)
);
COMMENT ON TABLE QUAD_technical_debt_scores IS 'Technical debt tracking';
