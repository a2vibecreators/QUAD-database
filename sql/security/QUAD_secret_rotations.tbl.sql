-- QUAD_secret_rotations Table
-- Secret rotation history
-- Part of: QUAD Security | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_secret_rotations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    secret_type VARCHAR(50) NOT NULL, secret_name VARCHAR(255),
    rotated_by UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    rotation_reason VARCHAR(100), old_key_hash VARCHAR(64),
    new_key_hash VARCHAR(64),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_secret_rotations IS 'Secret rotation history';
