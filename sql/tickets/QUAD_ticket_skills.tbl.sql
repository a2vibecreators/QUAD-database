-- QUAD_ticket_skills Table
-- Skills required for tickets (for smart assignment)
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ticket_skills (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id       UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    skill_id        UUID NOT NULL,  -- References QUAD_skills

    importance      VARCHAR(20) DEFAULT 'preferred',  -- required, preferred, nice_to_have

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(ticket_id, skill_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_skills_ticket ON QUAD_ticket_skills(ticket_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_skills_skill ON QUAD_ticket_skills(skill_id);

-- Comments
COMMENT ON TABLE QUAD_ticket_skills IS 'Skills required for tickets (for smart assignment)';
