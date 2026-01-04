-- QUAD_ai_user_memories Table
-- AI-learned user preferences and patterns
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_user_memories (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    memory_type     VARCHAR(50) NOT NULL,  -- coding_style, preferences, context
    memory_key      VARCHAR(100) NOT NULL,
    memory_value    TEXT NOT NULL,

    confidence      NUMERIC(3,2) DEFAULT 0.5,  -- 0.0 to 1.0
    source          VARCHAR(50),  -- inferred, explicit, imported

    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(user_id, memory_type, memory_key)
);

COMMENT ON TABLE QUAD_ai_user_memories IS 'AI-learned user preferences and patterns';
