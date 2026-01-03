-- Table: QUAD_domain_members
-- Section: core
-- Purpose: User membership in domains with role and allocation

CREATE TABLE QUAD_domain_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    -- Role within this domain
    role VARCHAR(50) NOT NULL,
    -- 'LEAD', 'DEVELOPER', 'QA', 'OBSERVER'

    -- Time allocation
    allocation_percentage INT DEFAULT 100,
    -- How much of user's time is allocated to this domain (0-100)

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    UNIQUE(user_id, domain_id)
);

-- Indexes
CREATE INDEX idx_quad_domain_members_user ON QUAD_domain_members(user_id);
CREATE INDEX idx_quad_domain_members_domain ON QUAD_domain_members(domain_id);
CREATE INDEX idx_quad_domain_members_role ON QUAD_domain_members(role);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_domain_members_updated_at
    BEFORE UPDATE ON QUAD_domain_members
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_domain_members IS 'User membership in domains. Users can belong to multiple domains with different allocations.';
COMMENT ON COLUMN QUAD_domain_members.allocation_percentage IS 'Percentage of time allocated to this domain. Sum across domains should equal 100.';
