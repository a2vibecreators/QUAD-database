-- QUAD_ticket_time_logs Table
-- Time tracking entries for tickets
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ticket_time_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id       UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    hours_logged    NUMERIC(5,2) NOT NULL,
    work_date       DATE NOT NULL,
    description     TEXT,

    -- Activity type
    activity_type   VARCHAR(50) DEFAULT 'development',  -- development, review, testing, meeting, research

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_time_logs_ticket ON QUAD_ticket_time_logs(ticket_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_time_logs_user ON QUAD_ticket_time_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_time_logs_date ON QUAD_ticket_time_logs(work_date);

-- Comments
COMMENT ON TABLE QUAD_ticket_time_logs IS 'Time tracking entries for tickets';
