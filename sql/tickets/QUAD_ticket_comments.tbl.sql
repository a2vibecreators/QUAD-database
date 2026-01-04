-- QUAD_ticket_comments Table
-- Comments and discussions on tickets
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ticket_comments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id       UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    content         TEXT NOT NULL,
    comment_type    VARCHAR(20) DEFAULT 'comment',  -- comment, status_change, assignment, ai_suggestion

    -- For AI-generated comments
    is_ai_generated BOOLEAN DEFAULT false,
    ai_provider     VARCHAR(20),

    parent_id       UUID REFERENCES QUAD_ticket_comments(id) ON DELETE CASCADE,  -- For threaded replies

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_comments_ticket ON QUAD_ticket_comments(ticket_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_comments_user ON QUAD_ticket_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_ticket_comments_parent ON QUAD_ticket_comments(parent_id);

-- Comments
COMMENT ON TABLE QUAD_ticket_comments IS 'Comments and discussions on tickets';
