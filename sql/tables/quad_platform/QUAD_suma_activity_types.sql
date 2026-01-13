-- asksuma.ai - Activity Types (Pre/Post Hooks System)
-- Purpose: Define activity types for SUMA's intelligent pre/post hook system
-- Created: January 10, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_activity_types (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Activity details
    code VARCHAR(50) UNIQUE NOT NULL, -- "set_alarm", "deploy_app", "generate_code", "interview_prep"
    name VARCHAR(200) NOT NULL, -- "Set Alarm", "Deploy App", "Generate Code"
    category VARCHAR(50) NOT NULL, -- "utility", "development", "education", "communication"
    description TEXT,

    -- Pre-hook configuration
    pre_hook_enabled BOOLEAN DEFAULT false,
    pre_hook_type VARCHAR(100), -- "check_weather", "check_quotas", "load_preferences"
    pre_hook_config JSONB, -- Configuration for pre-hook (API keys, endpoints, etc.)

    -- Post-hook configuration
    post_hook_enabled BOOLEAN DEFAULT false,
    post_hook_type VARCHAR(100), -- "send_email", "send_notification", "save_feedback"
    post_hook_config JSONB, -- Configuration for post-hook

    -- Activity metadata
    icon VARCHAR(10), -- Emoji for UI (🚀, ⏰, 💬, etc.)
    requires_auth BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    sort_order INT DEFAULT 0,

    -- Timestamps
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_suma_activity_types_code ON QUAD_suma_activity_types(code) WHERE is_active = true;
CREATE INDEX idx_suma_activity_types_category ON QUAD_suma_activity_types(category);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_suma_activity_types_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_suma_activity_types_updated_at
    BEFORE UPDATE ON QUAD_suma_activity_types
    FOR EACH ROW
    EXECUTE FUNCTION update_suma_activity_types_timestamp();

-- Comments
COMMENT ON TABLE QUAD_suma_activity_types IS 'Activity types for SUMA AI with pre/post hook configuration';
COMMENT ON COLUMN QUAD_suma_activity_types.code IS 'Unique activity code (set_alarm, deploy_app, generate_code, etc.)';
COMMENT ON COLUMN QUAD_suma_activity_types.pre_hook_type IS 'Pre-hook type (check_weather, check_quotas, load_preferences, etc.)';
COMMENT ON COLUMN QUAD_suma_activity_types.post_hook_type IS 'Post-hook type (send_email, send_notification, save_feedback, etc.)';
COMMENT ON COLUMN QUAD_suma_activity_types.pre_hook_config IS 'JSON configuration for pre-hook (API keys, endpoints, settings)';
COMMENT ON COLUMN QUAD_suma_activity_types.post_hook_config IS 'JSON configuration for post-hook (email templates, notification settings)';
