-- QUAD_core_roles Table
-- System-defined role templates (Management, Development, QA, Infrastructure)
--
-- Part of: QUAD Core
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_core_roles (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100) NOT NULL UNIQUE,
    display_name    VARCHAR(100) NOT NULL,
    description     TEXT,

    -- Default responsibilities
    responsibilities JSONB DEFAULT '[]',

    -- Circle mapping (1-4)
    circle_number   INTEGER,  -- 1=Management, 2=Development, 3=QA, 4=Infrastructure

    -- Permissions template
    permissions     JSONB DEFAULT '{}',

    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Seed default roles
INSERT INTO QUAD_core_roles (name, display_name, circle_number, description) VALUES
    ('MANAGER', 'Management', 1, 'Project/product management and coordination'),
    ('DEVELOPER', 'Development', 2, 'Software development and coding'),
    ('QA', 'Quality Assurance', 3, 'Testing and quality control'),
    ('INFRASTRUCTURE', 'Infrastructure', 4, 'DevOps, infrastructure, and deployment')
ON CONFLICT (name) DO NOTHING;

-- Comments
COMMENT ON TABLE QUAD_core_roles IS 'System-defined role templates (Management, Development, QA, Infrastructure)';
