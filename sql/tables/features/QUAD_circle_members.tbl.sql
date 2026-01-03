-- Table: QUAD_circle_members
-- Section: features
-- Purpose: User membership in circles

CREATE TABLE QUAD_circle_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    circle_id UUID NOT NULL REFERENCES QUAD_circles(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    role VARCHAR(50) DEFAULT 'member',
    -- 'lead', 'member', 'observer'

    allocation_pct INT DEFAULT 100,
    -- How much of user's domain time is in this circle

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    UNIQUE(circle_id, user_id)
);

-- Indexes
CREATE INDEX idx_quad_circle_members_circle ON QUAD_circle_members(circle_id);
CREATE INDEX idx_quad_circle_members_user ON QUAD_circle_members(user_id);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_circle_members_updated_at
    BEFORE UPDATE ON QUAD_circle_members
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_circle_members IS 'User membership in circles with role and allocation percentage.';
