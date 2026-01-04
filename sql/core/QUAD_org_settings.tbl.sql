-- QUAD_org_settings Table
-- Organization-level settings and preferences
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_org_settings (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    -- General Settings
    default_timezone    VARCHAR(50) DEFAULT 'UTC',
    date_format         VARCHAR(20) DEFAULT 'YYYY-MM-DD',
    week_starts_on      INTEGER DEFAULT 1,  -- 0=Sunday, 1=Monday

    -- AI Settings
    ai_tier             VARCHAR(20) DEFAULT 'balanced',
    default_ai_provider VARCHAR(20) DEFAULT 'claude',

    -- Integration Settings
    github_org          VARCHAR(100),
    slack_workspace_id  VARCHAR(50),
    jira_project_key    VARCHAR(20),

    -- Notification Settings
    email_notifications BOOLEAN DEFAULT true,
    slack_notifications BOOLEAN DEFAULT false,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(org_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_org_settings_org ON QUAD_org_settings(org_id);

-- Comments
COMMENT ON TABLE QUAD_org_settings IS 'Organization-level settings and preferences';
