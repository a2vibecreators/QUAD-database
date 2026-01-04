-- QUAD_assignment_scores Table
-- AI-calculated assignment scores for ticket-user pairs
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_assignment_scores (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id       UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- Scoring factors
    skill_match_score   NUMERIC(5,2),  -- 0-100
    workload_score      NUMERIC(5,2),  -- 0-100 (higher = less loaded)
    availability_score  NUMERIC(5,2),  -- 0-100
    experience_score    NUMERIC(5,2),  -- 0-100

    -- Final score
    total_score         NUMERIC(5,2),  -- Weighted average

    -- Recommendation
    is_recommended      BOOLEAN DEFAULT false,
    recommendation_rank INTEGER,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(ticket_id, user_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_assignment_scores_ticket ON QUAD_assignment_scores(ticket_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_assignment_scores_user ON QUAD_assignment_scores(user_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_assignment_scores_recommended ON QUAD_assignment_scores(is_recommended);

-- Comments
COMMENT ON TABLE QUAD_assignment_scores IS 'AI-calculated assignment scores for ticket-user pairs';
