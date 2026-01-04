-- QUAD_cycle_risk_predictions Table
-- AI-predicted cycle risks
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_cycle_risk_predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cycle_id UUID NOT NULL REFERENCES QUAD_cycles(id) ON DELETE CASCADE,
    risk_level VARCHAR(20) NOT NULL, risk_score NUMERIC(5,2),
    risk_factors JSONB, recommendations JSONB,
    predicted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_cycle_risk_predictions IS 'AI-predicted cycle risks';
