-- QUAD_user_skills Table
-- User skill levels
--
-- Part of: QUAD Skills
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_user_skills (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
    skill_id        UUID NOT NULL REFERENCES QUAD_skills(id) ON DELETE CASCADE,

    proficiency_level INTEGER DEFAULT 1,  -- 1-5
    years_experience NUMERIC(4,1),
    is_primary      BOOLEAN DEFAULT false,

    last_used_at    TIMESTAMP WITH TIME ZONE,
    verified_by     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    verified_at     TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(user_id, skill_id)
);

COMMENT ON TABLE QUAD_user_skills IS 'User skill levels';
