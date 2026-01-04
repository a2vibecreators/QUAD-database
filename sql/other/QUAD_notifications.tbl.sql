-- QUAD_notifications Table
-- User notifications
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_notifications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    notification_type VARCHAR(50) NOT NULL,  -- ticket_assigned, pr_review, mention, etc.
    title           VARCHAR(255) NOT NULL,
    message         TEXT,

    source_type     VARCHAR(50),  -- ticket, pr, comment, etc.
    source_id       UUID,
    action_url      TEXT,

    is_read         BOOLEAN DEFAULT false,
    read_at         TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_QUAD_notifications_user ON QUAD_notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_notifications_read ON QUAD_notifications(is_read);

COMMENT ON TABLE QUAD_notifications IS 'User notifications';
