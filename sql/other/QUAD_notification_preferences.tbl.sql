-- QUAD_notification_preferences Table
-- User notification preferences
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_notification_preferences (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    notification_type VARCHAR(50) NOT NULL,
    channel         VARCHAR(20) NOT NULL,  -- email, slack, in_app, push
    is_enabled      BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(user_id, notification_type, channel)
);

COMMENT ON TABLE QUAD_notification_preferences IS 'User notification preferences';
