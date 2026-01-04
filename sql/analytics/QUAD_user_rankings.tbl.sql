-- QUAD_user_rankings Table
-- Calculated user rankings
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_user_rankings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    config_id UUID REFERENCES QUAD_ranking_configs(id) ON DELETE SET NULL,
    period_date DATE NOT NULL, rank_position INTEGER,
    total_score NUMERIC(10,2), score_breakdown JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, config_id, period_date)
);
COMMENT ON TABLE QUAD_user_rankings IS 'Calculated user rankings';
