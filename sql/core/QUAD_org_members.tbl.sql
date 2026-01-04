-- QUAD_org_members Table
-- Organization membership (user belongs to org)
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_org_members (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    role            VARCHAR(50) DEFAULT 'member',  -- owner, admin, member
    status          VARCHAR(20) DEFAULT 'active',  -- active, suspended, pending

    invited_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    invited_at      TIMESTAMP WITH TIME ZONE,
    joined_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(org_id, user_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_QUAD_org_members_org ON QUAD_org_members(org_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_org_members_user ON QUAD_org_members(user_id);

-- Comments
COMMENT ON TABLE QUAD_org_members IS 'Organization membership (user belongs to org)';
