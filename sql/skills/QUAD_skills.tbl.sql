-- QUAD_skills Table
-- Skill definitions
--
-- Part of: QUAD Skills
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_skills (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    name            VARCHAR(100) NOT NULL,
    category        VARCHAR(50),  -- language, framework, tool, domain
    description     TEXT,

    is_system       BOOLEAN DEFAULT false,
    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_skills IS 'Skill definitions';
