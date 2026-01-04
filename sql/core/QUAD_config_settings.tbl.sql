-- QUAD_config_settings Table
-- Stores configuration settings per organization/domain/user
--
-- Hierarchy: ORG → DOMAIN → USER (more specific overrides less specific)
--
-- Part of: QUAD Configuration System
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_config_settings (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Scope (only one should be set, determines inheritance level)
    org_id          UUID,  -- References QUAD_organizations but no FK for flexibility
    domain_id       UUID,  -- References QUAD_domains
    user_id         UUID,  -- References QUAD_users

    -- Configuration category and key
    category        VARCHAR(50) NOT NULL,  -- 'tickets', 'ai', 'integrations', 'testing', etc.
    setting_key     VARCHAR(100) NOT NULL, -- 'estimation_preset', 'enable_junit', etc.

    -- Value (flexible storage)
    value_string    VARCHAR(500),          -- For string values
    value_boolean   BOOLEAN,               -- For true/false flags
    value_integer   INTEGER,               -- For numeric values
    value_json      TEXT,                  -- For complex objects (stored as JSON string)

    -- Metadata
    description     VARCHAR(255),          -- Human-readable description
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_by      UUID
);

-- Unique constraint: one setting per scope
CREATE UNIQUE INDEX IF NOT EXISTS idx_quad_config_org_key
    ON quad_config_settings(org_id, category, setting_key)
    WHERE org_id IS NOT NULL AND domain_id IS NULL AND user_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_quad_config_domain_key
    ON quad_config_settings(domain_id, category, setting_key)
    WHERE domain_id IS NOT NULL AND user_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_quad_config_user_key
    ON quad_config_settings(user_id, category, setting_key)
    WHERE user_id IS NOT NULL;

-- Indexes for lookups
CREATE INDEX IF NOT EXISTS idx_quad_config_category ON quad_config_settings(category);
CREATE INDEX IF NOT EXISTS idx_quad_config_key ON quad_config_settings(setting_key);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_quad_config_settings_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_quad_config_settings_updated ON quad_config_settings;
CREATE TRIGGER trg_quad_config_settings_updated
    BEFORE UPDATE ON quad_config_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_quad_config_settings_timestamp();

-- Comments
COMMENT ON TABLE quad_config_settings IS 'Configuration settings per org/domain/user';
COMMENT ON COLUMN quad_config_settings.category IS 'Setting category: tickets, ai, integrations, testing, etc.';
COMMENT ON COLUMN quad_config_settings.setting_key IS 'Setting name within category';

-- ============================================================================
-- MASTER CONFIGURATION DEFINITIONS (Insert default settings)
-- ============================================================================

-- These are the available configuration options (master set)
-- When an org is created, these defaults can be applied

-- Ticket Configuration (string values)
INSERT INTO quad_config_settings (org_id, category, setting_key, value_string, description) VALUES
(NULL, 'tickets', 'estimation_preset', 'platonic', 'Estimation system: platonic, dice, tshirt, fibonacci, powers'),
(NULL, 'tickets', 'type_abbreviation', 'short', 'Type format: short, long, emoji'),
(NULL, 'tickets', 'label_format', 'mathematical', 'Label format: mathematical, descriptive, simple, github, jira')
ON CONFLICT DO NOTHING;

-- Testing Configuration (boolean values)
INSERT INTO quad_config_settings (org_id, category, setting_key, value_boolean, description) VALUES
(NULL, 'testing', 'enable_junit', false, 'Generate JUnit test cases for Java services'),
(NULL, 'testing', 'enable_integration_tests', false, 'Generate integration test scripts'),
(NULL, 'testing', 'run_tests_on_build', false, 'Run tests automatically during build')
ON CONFLICT DO NOTHING;

-- AI Configuration (boolean values)
INSERT INTO quad_config_settings (org_id, category, setting_key, value_boolean, description) VALUES
(NULL, 'ai', 'enable_code_review', true, 'Enable AI code review agent'),
(NULL, 'ai', 'enable_code_generation', true, 'Enable AI code generation'),
(NULL, 'ai', 'enable_docs_generation', true, 'Enable AI documentation generation'),
(NULL, 'ai', 'enable_test_generation', false, 'Enable AI test case generation')
ON CONFLICT DO NOTHING;

-- Integration Toggles (boolean values)
INSERT INTO quad_config_settings (org_id, category, setting_key, value_boolean, description) VALUES
(NULL, 'integrations', 'enable_github', true, 'Enable GitHub integration'),
(NULL, 'integrations', 'enable_jira', false, 'Enable Jira integration'),
(NULL, 'integrations', 'enable_slack', false, 'Enable Slack notifications'),
(NULL, 'integrations', 'enable_calendar', false, 'Enable Google Calendar sync')
ON CONFLICT DO NOTHING;

-- Sandbox Configuration (boolean values)
INSERT INTO quad_config_settings (org_id, category, setting_key, value_boolean, description) VALUES
(NULL, 'sandbox', 'enable_sandboxes', true, 'Enable development sandboxes'),
(NULL, 'sandbox', 'auto_provision', false, 'Auto-provision sandbox on ticket creation')
ON CONFLICT DO NOTHING;

-- Sandbox Configuration (integer values)
INSERT INTO quad_config_settings (org_id, category, setting_key, value_integer, description) VALUES
(NULL, 'sandbox', 'max_concurrent', 5, 'Maximum concurrent sandboxes')
ON CONFLICT DO NOTHING;

-- Adoption Level (stored as integer)
INSERT INTO quad_config_settings (org_id, category, setting_key, value_integer, description) VALUES
(NULL, 'adoption', 'level', 4, 'Adoption level: 0=Origin, 1=Vector, 2=Plane, 3=Space, 4=Hyperspace')
ON CONFLICT DO NOTHING;
