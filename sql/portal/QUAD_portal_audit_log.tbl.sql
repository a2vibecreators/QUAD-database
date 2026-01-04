-- QUAD_portal_audit_log Table
-- Portal admin action audit log
--
-- Part of: QUAD Portal
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_portal_audit_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    action          VARCHAR(100) NOT NULL,
    resource_type   VARCHAR(50),  -- organization, user, billing, etc.
    resource_id     UUID,

    old_value       JSONB,
    new_value       JSONB,

    ip_address      VARCHAR(50),
    user_agent      TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_QUAD_portal_audit_user ON QUAD_portal_audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_portal_audit_action ON QUAD_portal_audit_log(action);
CREATE INDEX IF NOT EXISTS idx_QUAD_portal_audit_created ON QUAD_portal_audit_log(created_at);

COMMENT ON TABLE QUAD_portal_audit_log IS 'Portal admin action audit log';
