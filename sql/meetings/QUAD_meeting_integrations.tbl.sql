-- QUAD_meeting_integrations Table
-- Calendar integrations (Google Calendar, Outlook)
--
-- Part of: QUAD Meetings
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_meeting_integrations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    provider        VARCHAR(20) NOT NULL,  -- google, outlook, zoom
    access_token_vault_path VARCHAR(255),
    refresh_token_vault_path VARCHAR(255),

    calendar_id     VARCHAR(255),
    status          VARCHAR(20) DEFAULT 'active',
    last_sync_at    TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_meeting_integrations IS 'Calendar integrations (Google Calendar, Outlook)';
