-- QUAD_context_sessions Table
-- AI conversation sessions with context
--
-- Part of: QUAD Memory
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_context_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE SET NULL,

    session_type    VARCHAR(50) DEFAULT 'chat',  -- chat, code_review, analysis
    title           VARCHAR(255),

    -- Context state
    context_documents JSONB,  -- Array of document IDs included
    token_usage     INTEGER DEFAULT 0,

    status          VARCHAR(20) DEFAULT 'active',  -- active, completed, expired
    expires_at      TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_context_sessions IS 'AI conversation sessions with context';
