-- QUAD_activity_types Table
-- Catalog of development activity types for AI agent rules
--
-- Purpose:
-- Define available activity types that developers can perform
-- Each activity type has specific coding rules (DO's and DON'Ts)
--
-- Activity Types:
-- 1. add_api_endpoint - Create new REST API endpoint (Controller + Service + Repository)
-- 2. create_ui_screen - Create new web page or mobile screen
-- 3. add_database_table - Create new database table with migration
-- 4. add_payment_processing - Integrate payment gateway (Stripe, PayPal, etc.)
-- 5. add_authentication - Add login/signup functionality
-- 6. add_file_upload - Handle file uploads to cloud storage
--
-- Integration with QUAD Flow:
-- - Used by VS Code extension to fetch relevant rules
-- - Works with QUAD Sync (Jira, GitHub, Slack, Zoom, Email)
-- - Expandable (new activity types can be added without code changes)
--
-- Part of: QUAD AI Agent Rules System
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_activity_types (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Activity identification
    activity_code   VARCHAR(100) UNIQUE NOT NULL,   -- Snake_case identifier
    display_name    VARCHAR(200) NOT NULL,          -- Human-readable name
    description     TEXT,                           -- Detailed description

    -- Categorization
    category        VARCHAR(50),                    -- 'backend', 'frontend', 'database', 'infrastructure', 'integration'

    -- Integration targeting (which tools/integrations this activity relates to)
    integrations    JSONB,                          -- ["jira", "github", "slack", "zoom", "email"]

    -- Icon/Visual (for UI)
    icon_emoji      VARCHAR(10),                    -- e.g., '🔌' for add_api_endpoint
    color_code      VARCHAR(20),                    -- e.g., 'blue', '#4F46E5'

    -- Metadata
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_activity_types_code
    ON quad_activity_types(activity_code)
    WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_quad_activity_types_category
    ON quad_activity_types(category)
    WHERE is_active = true;

-- Comments
COMMENT ON TABLE quad_activity_types IS 'Catalog of development activity types for AI agent rules';
COMMENT ON COLUMN quad_activity_types.activity_code IS 'Unique snake_case identifier (e.g., add_api_endpoint)';
COMMENT ON COLUMN quad_activity_types.category IS 'Activity category for grouping (backend, frontend, database, infrastructure, integration)';
COMMENT ON COLUMN quad_activity_types.integrations IS 'JSONB array of related integrations (jira, github, slack, zoom, email)';
