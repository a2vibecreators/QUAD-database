-- QUAD_messenger_channels Table
-- Connected messenger channels (Slack, Teams, Discord, WhatsApp, Email, SMS)
-- Part of: QUAD Messenger | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_messenger_channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    -- Channel identification
    channel_type VARCHAR(20) NOT NULL,          -- 'slack', 'teams', 'discord', 'whatsapp', 'email', 'sms'
    channel_name VARCHAR(100),                  -- "#dev-team" or "Engineering Chat"
    channel_id VARCHAR(100) NOT NULL,           -- External ID (Slack channel ID, Teams channel ID, etc.)

    -- Connection details
    workspace_id VARCHAR(100),                  -- Slack workspace, Teams tenant, Discord server
    webhook_url TEXT,                           -- For sending messages
    bot_token_path VARCHAR(255),                -- Vault path to bot token (not stored here!)

    -- Configuration
    is_active BOOLEAN DEFAULT true,
    notification_types TEXT[],                  -- What to send here: ['ticket_created', 'pr_merged', 'deploy_complete']

    -- Audit
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES QUAD_users(id),

    CONSTRAINT valid_channel_type CHECK (channel_type IN ('slack', 'teams', 'discord', 'whatsapp', 'email', 'sms'))
);

-- Indexes
CREATE INDEX idx_messenger_channels_org ON QUAD_messenger_channels(org_id);
CREATE INDEX idx_messenger_channels_type ON QUAD_messenger_channels(channel_type);
CREATE INDEX idx_messenger_channels_active ON QUAD_messenger_channels(org_id, is_active) WHERE is_active = true;

-- Trigger for updated_at
CREATE TRIGGER trg_messenger_channels_updated_at
    BEFORE UPDATE ON QUAD_messenger_channels
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE QUAD_messenger_channels IS 'Connected messenger channels per organization (Slack, Teams, Discord, WhatsApp, Email, SMS)';
COMMENT ON COLUMN QUAD_messenger_channels.channel_type IS 'Channel platform: slack, teams, discord, whatsapp, email, sms';
COMMENT ON COLUMN QUAD_messenger_channels.bot_token_path IS 'Vault path to credentials - never store tokens directly';
COMMENT ON COLUMN QUAD_messenger_channels.notification_types IS 'Array of event types to send to this channel';
