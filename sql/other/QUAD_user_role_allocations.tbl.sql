-- QUAD_user_role_allocations Table
-- User time allocation across roles
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_user_role_allocations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    role_id         UUID NOT NULL REFERENCES QUAD_roles(id) ON DELETE CASCADE,

    allocation_pct  INTEGER DEFAULT 100,
    effective_date  DATE NOT NULL,
    end_date        DATE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(user_id, role_id, effective_date)
);

COMMENT ON TABLE QUAD_user_role_allocations IS 'User time allocation across roles';
