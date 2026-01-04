-- QUAD_slack_bot_commands Table
-- Slack bot command history
-- Part of: QUAD Slack | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_slack_bot_commands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID REFERENCES QUAD_organizations(id) ON DELETE SET NULL,
    user_id UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    slack_user_id VARCHAR(50), channel_id VARCHAR(50),
    command VARCHAR(100) NOT NULL, args TEXT,
    response TEXT, status VARCHAR(20) DEFAULT 'completed',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_slack_bot_commands IS 'Slack bot command history';
