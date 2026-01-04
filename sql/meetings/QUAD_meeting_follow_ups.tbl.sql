-- QUAD_meeting_follow_ups Table
-- Follow-up tasks generated from meetings
--
-- Part of: QUAD Meetings
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_meeting_follow_ups (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    meeting_id      UUID NOT NULL REFERENCES QUAD_meetings(id) ON DELETE CASCADE,

    title           VARCHAR(255) NOT NULL,
    description     TEXT,

    follow_up_type  VARCHAR(50) DEFAULT 'task',  -- task, decision, discussion, blocker
    priority        VARCHAR(20) DEFAULT 'medium',

    assignee_id     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    status          VARCHAR(20) DEFAULT 'pending',
    resolved_at     TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_meeting_follow_ups IS 'Follow-up tasks generated from meetings';
