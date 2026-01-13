-- asksuma.ai - Chat History (Iterative Refinement)
-- Purpose: Store chat messages for iterative app development
-- Created: January 10, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_chats (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign keys
    app_id UUID NOT NULL REFERENCES QUAD_suma_apps(id) ON DELETE CASCADE,
    user_id UUID REFERENCES QUAD_users(id), -- Who sent the message

    -- Message details
    role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
    message TEXT NOT NULL,

    -- AI metadata (if role = 'assistant')
    model_used VARCHAR(50), -- "gemini-2.0-flash"
    tokens_used INT,
    response_time_ms INT,

    -- Action tracking (if message triggered code update)
    triggered_update BOOLEAN DEFAULT false,
    deployment_id UUID, -- Link to deployment record if update was deployed

    -- Timestamp
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_suma_chats_app ON QUAD_suma_chats(app_id, created_at DESC);
CREATE INDEX idx_suma_chats_user ON QUAD_suma_chats(user_id);
CREATE INDEX idx_suma_chats_triggered ON QUAD_suma_chats(app_id, triggered_update) WHERE triggered_update = true;

-- Comments
COMMENT ON TABLE QUAD_suma_chats IS 'Chat history for iterative app development on asksuma.ai';
COMMENT ON COLUMN QUAD_suma_chats.role IS 'Message sender (user, assistant, system)';
COMMENT ON COLUMN QUAD_suma_chats.triggered_update IS 'True if this message caused code regeneration';
COMMENT ON COLUMN QUAD_suma_chats.deployment_id IS 'Link to deployment if message triggered update';
