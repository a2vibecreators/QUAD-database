-- QUAD_slack_messages Table
-- Slack messages sent by QUAD
-- Part of: QUAD Slack | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_slack_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID REFERENCES QUAD_organizations(id) ON DELETE SET NULL,
    channel_id VARCHAR(50) NOT NULL, thread_ts VARCHAR(50),
    message_type VARCHAR(50) NOT NULL, content JSONB NOT NULL,
    slack_ts VARCHAR(50), status VARCHAR(20) DEFAULT 'sent',
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_slack_messages IS 'Slack messages sent by QUAD';
