-- QUAD_org_invitations Table
-- Pending invitations to join organization
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_org_invitations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    email           VARCHAR(255) NOT NULL,
    role            VARCHAR(50) DEFAULT 'member',
    token           VARCHAR(255) NOT NULL UNIQUE,

    invited_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    status          VARCHAR(20) DEFAULT 'pending',  -- pending, accepted, expired, revoked
    expires_at      TIMESTAMP WITH TIME ZONE NOT NULL,
    accepted_at     TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_org_invitations_org ON QUAD_org_invitations(org_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_org_invitations_email ON QUAD_org_invitations(email);
CREATE INDEX IF NOT EXISTS idx_QUAD_org_invitations_token ON QUAD_org_invitations(token);

-- Comments
COMMENT ON TABLE QUAD_org_invitations IS 'Pending invitations to join organization';
