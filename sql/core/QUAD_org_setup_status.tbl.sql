-- QUAD_org_setup_status Table
-- Tracks organization onboarding/setup progress
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_org_setup_status (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    -- Setup Steps
    step_profile_completed      BOOLEAN DEFAULT false,
    step_team_invited           BOOLEAN DEFAULT false,
    step_domain_created         BOOLEAN DEFAULT false,
    step_git_connected          BOOLEAN DEFAULT false,
    step_first_ticket_created   BOOLEAN DEFAULT false,

    -- Timestamps
    profile_completed_at    TIMESTAMP WITH TIME ZONE,
    team_invited_at         TIMESTAMP WITH TIME ZONE,
    domain_created_at       TIMESTAMP WITH TIME ZONE,
    git_connected_at        TIMESTAMP WITH TIME ZONE,
    first_ticket_at         TIMESTAMP WITH TIME ZONE,

    -- Overall Status
    setup_completed         BOOLEAN DEFAULT false,
    setup_completed_at      TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(org_id)
);

-- Comments
COMMENT ON TABLE QUAD_org_setup_status IS 'Tracks organization onboarding/setup progress';
