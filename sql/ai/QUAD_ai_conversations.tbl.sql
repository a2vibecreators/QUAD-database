-- QUAD_ai_conversations Table
-- AI chat conversations
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_conversations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE SET NULL,

    title           VARCHAR(255),
    conversation_type VARCHAR(50) DEFAULT 'general',

    provider        VARCHAR(20),
    model           VARCHAR(100),

    total_tokens    INTEGER DEFAULT 0,
    message_count   INTEGER DEFAULT 0,

    is_archived     BOOLEAN DEFAULT false,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_conversations IS 'AI chat conversations';
