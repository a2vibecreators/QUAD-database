-- QUAD_portal_access Table
-- Portal access permissions
--
-- Part of: QUAD Portal
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_portal_access (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    access_level    VARCHAR(20) DEFAULT 'viewer',  -- viewer, operator, admin, super_admin
    scopes          TEXT[],  -- Specific scopes: organizations, users, billing, etc.

    granted_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    granted_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at      TIMESTAMP WITH TIME ZONE,

    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_portal_access IS 'Portal access permissions';
