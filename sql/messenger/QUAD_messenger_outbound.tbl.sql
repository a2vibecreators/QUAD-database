-- QUAD_messenger_outbound Table
-- Messages sent by QUAD to messenger channels (notifications, responses)
-- Part of: QUAD Messenger | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_messenger_outbound (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID REFERENCES QUAD_organizations(id) ON DELETE SET NULL,
    channel_id UUID REFERENCES QUAD_messenger_channels(id) ON DELETE SET NULL,

    -- What triggered this message
    trigger_type VARCHAR(50) NOT NULL,          -- 'ticket_created', 'pr_review', 'deploy_complete', 'reminder', 'command_response'
    trigger_id UUID,                            -- Related entity ID (ticket_id, pr_id, etc.)
    command_id UUID REFERENCES QUAD_messenger_commands(id), -- If responding to a command

    -- Message content
    message_type VARCHAR(20) NOT NULL,          -- 'text', 'card', 'button', 'file'
    message_template VARCHAR(100),              -- Template used (for consistency tracking)
    message_content JSONB NOT NULL,             -- Structured content (channel-specific format)

    -- Targeting
    target_thread_id VARCHAR(100),              -- Reply to specific thread
    target_user_id VARCHAR(100),                -- DM to specific user (external ID)

    -- Delivery status
    status VARCHAR(20) DEFAULT 'pending',       -- pending, sent, delivered, failed, cancelled
    external_message_id VARCHAR(100),           -- Message ID from the platform
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,

    -- Timing
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP WITH TIME ZONE,

    CONSTRAINT valid_outbound_status CHECK (status IN ('pending', 'sent', 'delivered', 'failed', 'cancelled')),
    CONSTRAINT valid_message_type CHECK (message_type IN ('text', 'card', 'button', 'file'))
);

-- Indexes
CREATE INDEX idx_messenger_outbound_org ON QUAD_messenger_outbound(org_id);
CREATE INDEX idx_messenger_outbound_channel ON QUAD_messenger_outbound(channel_id);
CREATE INDEX idx_messenger_outbound_status ON QUAD_messenger_outbound(status);
CREATE INDEX idx_messenger_outbound_trigger ON QUAD_messenger_outbound(trigger_type, trigger_id);
CREATE INDEX idx_messenger_outbound_pending ON QUAD_messenger_outbound(status, created_at) WHERE status = 'pending';

COMMENT ON TABLE QUAD_messenger_outbound IS 'Messages sent BY QUAD to messenger channels (not incoming messages)';
COMMENT ON COLUMN QUAD_messenger_outbound.trigger_type IS 'What event triggered this message: ticket_created, pr_review, deploy_complete, reminder';
COMMENT ON COLUMN QUAD_messenger_outbound.message_content IS 'Channel-specific format: Slack blocks, Teams cards, Discord embeds';
COMMENT ON COLUMN QUAD_messenger_outbound.message_template IS 'Template code used for analytics and consistency';
