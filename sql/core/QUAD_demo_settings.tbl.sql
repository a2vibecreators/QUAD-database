-- QUAD_demo_settings Table
-- Stores feature toggle settings per organization for demos
--
-- Links org_id from QUAD_organizations to enabled features
-- Used by demo pages to show/hide features based on org config
--
-- Part of: QUAD Core Schema
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_demo_settings (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Organization link
    org_id          UUID NOT NULL,                 -- References QUAD_organizations.id

    -- Settings identification
    config_name     VARCHAR(100) NOT NULL DEFAULT 'default',  -- 'default', 'pilot', 'full'

    -- Preset used
    preset_key      VARCHAR(50),                   -- 'FULL_MATRIX', 'PILOT_VECTOR', 'GROWTH_PLANE', 'CUSTOM_PATH'

    -- Feature toggles (JSON)
    enabled_features    JSONB NOT NULL DEFAULT '{}'::JSONB,  -- { "featureKey": true/false }

    -- Metadata
    description     VARCHAR(255),
    is_default      BOOLEAN DEFAULT false,
    is_active       BOOLEAN DEFAULT true,

    -- Audit
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by      UUID,

    -- Unique: one config name per org
    UNIQUE (org_id, config_name)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_demo_settings_org ON quad_demo_settings(org_id);
CREATE INDEX IF NOT EXISTS idx_quad_demo_settings_default ON quad_demo_settings(org_id, is_default) WHERE is_default = true;

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_quad_demo_settings_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_quad_demo_settings_updated ON quad_demo_settings;
CREATE TRIGGER trg_quad_demo_settings_updated
    BEFORE UPDATE ON quad_demo_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_quad_demo_settings_timestamp();

-- Comments
COMMENT ON TABLE quad_demo_settings IS 'Feature toggle settings per organization for demos';
COMMENT ON COLUMN quad_demo_settings.org_id IS 'References QUAD_organizations.id';
COMMENT ON COLUMN quad_demo_settings.preset_key IS 'FULL_MATRIX, PILOT_VECTOR, GROWTH_PLANE, CUSTOM_PATH';
COMMENT ON COLUMN quad_demo_settings.enabled_features IS 'JSON: { "featureKey": true/false }';
