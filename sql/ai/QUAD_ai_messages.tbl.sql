-- QUAD_ai_messages Table
-- Messages within AI conversations
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_messages (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES QUAD_ai_conversations(id) ON DELETE CASCADE,

    role            VARCHAR(20) NOT NULL,  -- user, assistant, system
    content         TEXT NOT NULL,

    tokens          INTEGER DEFAULT 0,
    latency_ms      INTEGER,

    -- For code blocks
    code_language   VARCHAR(50),
    code_content    TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_messages IS 'Messages within AI conversations';
