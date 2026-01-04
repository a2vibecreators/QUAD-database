-- QUAD_circle_members Table
-- User membership in circles with role and allocation percentage
--
-- Part of: QUAD Tickets
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_circle_members (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id       UUID NOT NULL REFERENCES quad_circles(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,
    role            VARCHAR(50) DEFAULT 'member',  -- lead, member
    allocation_pct  INTEGER DEFAULT 100,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),

    UNIQUE(circle_id, user_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_circle_members_circle ON quad_circle_members(circle_id);
CREATE INDEX IF NOT EXISTS idx_quad_circle_members_user ON quad_circle_members(user_id);

-- Comments
COMMENT ON TABLE quad_circle_members IS 'User membership in circles with role and allocation percentage.';
