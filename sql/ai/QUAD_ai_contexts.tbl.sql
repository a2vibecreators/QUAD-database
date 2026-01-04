-- QUAD_ai_contexts Table
-- Stored AI contexts for reuse
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_contexts (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    name            VARCHAR(255) NOT NULL,
    context_type    VARCHAR(50) DEFAULT 'general',  -- codebase, architecture, api, testing
    content         TEXT NOT NULL,
    token_count     INTEGER DEFAULT 0,

    is_active       BOOLEAN DEFAULT true,
    auto_include    BOOLEAN DEFAULT false,

    created_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_contexts IS 'Stored AI contexts for reuse';
