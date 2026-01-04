-- QUAD_meeting_action_items Table
-- Action items from meetings
--
-- Part of: QUAD Meetings
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_meeting_action_items (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    meeting_id      UUID NOT NULL REFERENCES QUAD_meetings(id) ON DELETE CASCADE,

    description     TEXT NOT NULL,
    assignee_id     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    due_date        DATE,

    status          VARCHAR(20) DEFAULT 'open',  -- open, in_progress, completed
    completed_at    TIMESTAMP WITH TIME ZONE,

    -- Link to ticket if converted
    ticket_id       UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_meeting_action_items IS 'Action items from meetings';
