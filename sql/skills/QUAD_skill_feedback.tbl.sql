-- QUAD_skill_feedback Table
-- Skill assessment feedback
--
-- Part of: QUAD Skills
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_skill_feedback (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_skill_id   UUID NOT NULL REFERENCES QUAD_user_skills(id) ON DELETE CASCADE,
    reviewer_id     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    rating          INTEGER,  -- 1-5
    comment         TEXT,
    context         VARCHAR(100),  -- code_review, ticket_completion, etc.

    ticket_id       UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_skill_feedback IS 'Skill assessment feedback';
