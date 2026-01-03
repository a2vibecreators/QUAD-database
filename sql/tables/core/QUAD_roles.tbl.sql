-- Table: QUAD_roles
-- Section: core
-- Purpose: Define roles that can be assigned to users within a company
-- Roles are company-specific so each company can customize their own

CREATE TABLE QUAD_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES QUAD_companies(id) ON DELETE CASCADE,

    -- Role identification
    role_code VARCHAR(50) NOT NULL,
    -- Examples: 'ADMIN', 'MANAGER', 'DEVELOPER', 'QA', 'DEVOPS', 'OBSERVER'

    role_name VARCHAR(100) NOT NULL,
    -- Display name: 'Administrator', 'Project Manager', 'Developer', etc.

    description TEXT,

    -- Permission flags
    can_manage_company BOOLEAN DEFAULT FALSE,    -- Company settings, billing
    can_manage_users BOOLEAN DEFAULT FALSE,      -- Add/remove users, change roles
    can_manage_domains BOOLEAN DEFAULT FALSE,    -- Create/edit domains
    can_manage_flows BOOLEAN DEFAULT FALSE,      -- Create/assign flows
    can_view_all_metrics BOOLEAN DEFAULT FALSE,  -- See all user metrics
    can_manage_circles BOOLEAN DEFAULT FALSE,    -- Create/edit circles
    can_manage_resources BOOLEAN DEFAULT FALSE,  -- Manage domain resources

    -- Q-U-A-D Stage Participation
    -- Values: 'PRIMARY' (owns the stage), 'SUPPORT' (helps), 'REVIEW' (approves), 'INFORM' (notified), NULL (not involved)
    q_participation VARCHAR(10),  -- Question stage: who receives/clarifies requests
    u_participation VARCHAR(10),  -- Understand stage: who analyzes/designs solutions
    a_participation VARCHAR(10),  -- Allocate stage: who assigns work/resources
    d_participation VARCHAR(10),  -- Deliver stage: who implements/delivers

    -- UI display
    color_code VARCHAR(20),     -- Hex color for badges: '#3B82F6'
    icon_name VARCHAR(50),      -- Icon name: 'shield', 'code', 'settings'
    display_order INTEGER DEFAULT 0,

    -- Role hierarchy (higher = more authority)
    hierarchy_level INTEGER DEFAULT 0,
    -- 100 = Super Admin, 80 = Admin, 60 = Manager, 40 = Developer, 20 = Observer

    -- Status
    is_system_role BOOLEAN DEFAULT FALSE,  -- TRUE = cannot be deleted
    is_active BOOLEAN DEFAULT TRUE,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    UNIQUE(company_id, role_code)
);

-- Indexes
CREATE INDEX idx_quad_roles_company ON QUAD_roles(company_id);
CREATE INDEX idx_quad_roles_code ON QUAD_roles(role_code);
CREATE INDEX idx_quad_roles_active ON QUAD_roles(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_quad_roles_order ON QUAD_roles(display_order);
CREATE INDEX idx_quad_roles_hierarchy ON QUAD_roles(hierarchy_level);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_roles_updated_at
    BEFORE UPDATE ON QUAD_roles
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_roles IS 'Company-specific role definitions. Each company can customize roles and permissions.';
COMMENT ON COLUMN QUAD_roles.is_system_role IS 'System roles (ADMIN, DEVELOPER) cannot be deleted, only deactivated.';
COMMENT ON COLUMN QUAD_roles.hierarchy_level IS 'Higher number = more authority. Used for permission inheritance.';
COMMENT ON COLUMN QUAD_roles.q_participation IS 'Question stage participation: PRIMARY (receives requests), SUPPORT, REVIEW, INFORM';
COMMENT ON COLUMN QUAD_roles.u_participation IS 'Understand stage participation: PRIMARY (analyzes/designs), SUPPORT, REVIEW, INFORM';
COMMENT ON COLUMN QUAD_roles.a_participation IS 'Allocate stage participation: PRIMARY (assigns work), SUPPORT, REVIEW, INFORM';
COMMENT ON COLUMN QUAD_roles.d_participation IS 'Deliver stage participation: PRIMARY (implements), SUPPORT, REVIEW, INFORM';
