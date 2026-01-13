-- asksuma.ai - User Context Storage
-- Purpose: Store user preferences and conversation context for personalized experience
-- Created: January 10, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_user_context (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign keys
    org_id UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    app_id UUID REFERENCES QUAD_suma_apps(id) ON DELETE CASCADE, -- NULL if general context

    -- Context data
    context_type VARCHAR(50) NOT NULL, -- "preferences", "conversation_state", "app_config", "inspiration"
    context_key VARCHAR(100) NOT NULL, -- "preferred_framework", "last_template", "reference_urls"
    context_value JSONB NOT NULL, -- Flexible JSON storage

    -- Metadata
    expires_at TIMESTAMP, -- Optional expiration for temporary context

    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Unique constraint: one key per user/app combination
    UNIQUE(user_id, app_id, context_type, context_key)
);

-- Indexes
CREATE INDEX idx_suma_user_context_user ON QUAD_suma_user_context(user_id);
CREATE INDEX idx_suma_user_context_app ON QUAD_suma_user_context(app_id) WHERE app_id IS NOT NULL;
CREATE INDEX idx_suma_user_context_type ON QUAD_suma_user_context(context_type);
CREATE INDEX idx_suma_user_context_expires ON QUAD_suma_user_context(expires_at) WHERE expires_at IS NOT NULL;

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_suma_user_context_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_suma_user_context_updated_at
    BEFORE UPDATE ON QUAD_suma_user_context
    FOR EACH ROW
    EXECUTE FUNCTION update_suma_user_context_timestamp();

-- Comments
COMMENT ON TABLE QUAD_suma_user_context IS 'User context and preferences for personalized asksuma.ai experience';
COMMENT ON COLUMN QUAD_suma_user_context.context_type IS 'Type of context (preferences, conversation_state, app_config, inspiration)';
COMMENT ON COLUMN QUAD_suma_user_context.context_key IS 'Context identifier (preferred_framework, last_template, etc.)';
COMMENT ON COLUMN QUAD_suma_user_context.context_value IS 'JSON value for flexible storage';

-- Example usage:
-- INSERT INTO QUAD_suma_user_context (org_id, user_id, context_type, context_key, context_value)
-- VALUES ('...', '...', 'preferences', 'preferred_framework', '{"frontend": "Next.js", "backend": "Node.js"}');
