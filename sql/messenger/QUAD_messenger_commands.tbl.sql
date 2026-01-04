-- QUAD_messenger_commands Table
-- Commands/triggers received from messenger channels (NOT chat content)
-- Part of: QUAD Messenger | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_messenger_commands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID REFERENCES QUAD_organizations(id) ON DELETE SET NULL,
    channel_id UUID REFERENCES QUAD_messenger_channels(id) ON DELETE SET NULL,

    -- Who triggered
    user_id UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    external_user_id VARCHAR(100),              -- Slack user ID, Teams user ID, etc.
    external_user_name VARCHAR(100),            -- Display name (for audit)

    -- The command (NOT full message content!)
    command VARCHAR(100) NOT NULL,              -- 'create-ticket', 'status', 'assign', 'deploy'
    args JSONB,                                 -- Parsed arguments {"title": "...", "priority": "high"}
    raw_text TEXT,                              -- Original command text (for debugging only)

    -- Thread context (if reply)
    thread_id VARCHAR(100),                     -- Thread/conversation ID
    is_thread_reply BOOLEAN DEFAULT false,

    -- Result
    status VARCHAR(20) DEFAULT 'received',      -- received, processing, completed, failed
    response_summary TEXT,                      -- Brief summary of what QUAD did
    error_message TEXT,

    -- Timing
    received_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP WITH TIME ZONE,

    CONSTRAINT valid_command_status CHECK (status IN ('received', 'processing', 'completed', 'failed'))
);

-- Indexes
CREATE INDEX idx_messenger_commands_org ON QUAD_messenger_commands(org_id);
CREATE INDEX idx_messenger_commands_user ON QUAD_messenger_commands(user_id);
CREATE INDEX idx_messenger_commands_channel ON QUAD_messenger_commands(channel_id);
CREATE INDEX idx_messenger_commands_status ON QUAD_messenger_commands(status);
CREATE INDEX idx_messenger_commands_received ON QUAD_messenger_commands(received_at DESC);

COMMENT ON TABLE QUAD_messenger_commands IS 'Commands/triggers from messenger channels - NOT chat message storage';
COMMENT ON COLUMN QUAD_messenger_commands.command IS 'Command name: create-ticket, status, assign, deploy, help';
COMMENT ON COLUMN QUAD_messenger_commands.args IS 'Parsed command arguments as JSON';
COMMENT ON COLUMN QUAD_messenger_commands.raw_text IS 'Original command text for debugging - NOT full chat content';
