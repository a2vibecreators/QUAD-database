-- QUAD_ai_context_relationships Table
-- Relationships between AI contexts
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_context_relationships (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_context_id UUID NOT NULL REFERENCES QUAD_ai_contexts(id) ON DELETE CASCADE,
    child_context_id UUID NOT NULL REFERENCES QUAD_ai_contexts(id) ON DELETE CASCADE,

    relationship_type VARCHAR(50) DEFAULT 'includes',  -- includes, extends, depends_on

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(parent_context_id, child_context_id)
);

COMMENT ON TABLE QUAD_ai_context_relationships IS 'Relationships between AI contexts';
