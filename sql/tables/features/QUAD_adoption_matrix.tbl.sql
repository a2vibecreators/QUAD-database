-- Table: QUAD_adoption_matrix
-- Section: features
-- Purpose: Track user position on Skill × Trust matrix for AI adoption

CREATE TABLE QUAD_adoption_matrix (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    -- 3×3 Matrix Position (can extend to 5×5 later)
    skill_level INT NOT NULL DEFAULT 1,
    -- 1 = Beginner, 2 = Intermediate, 3 = Expert

    trust_level INT NOT NULL DEFAULT 1,
    -- 1 = Low Trust, 2 = Medium Trust, 3 = High Trust

    -- Calculated zone name based on position
    zone_name VARCHAR(50) GENERATED ALWAYS AS (
        CASE
            WHEN skill_level = 1 AND trust_level = 1 THEN 'AI Skeptic'
            WHEN skill_level = 1 AND trust_level = 2 THEN 'Curious Novice'
            WHEN skill_level = 1 AND trust_level = 3 THEN 'Trusting Novice'
            WHEN skill_level = 2 AND trust_level = 1 THEN 'Skeptical User'
            WHEN skill_level = 2 AND trust_level = 2 THEN 'Growing User'
            WHEN skill_level = 2 AND trust_level = 3 THEN 'Eager Adopter'
            WHEN skill_level = 3 AND trust_level = 1 THEN 'Cautious Expert'
            WHEN skill_level = 3 AND trust_level = 2 THEN 'Balanced Expert'
            WHEN skill_level = 3 AND trust_level = 3 THEN 'AI Champion'
            ELSE 'Unknown'
        END
    ) STORED,

    -- Safety buffer percentage (decreases as skill+trust increases)
    safety_buffer_pct INT GENERATED ALWAYS AS (
        CASE
            WHEN skill_level = 1 AND trust_level = 1 THEN 80  -- AI Skeptic: Maximum buffer
            WHEN skill_level = 1 AND trust_level = 2 THEN 60  -- Curious Novice
            WHEN skill_level = 1 AND trust_level = 3 THEN 50  -- Trusting Novice
            WHEN skill_level = 2 AND trust_level = 1 THEN 60  -- Skeptical User
            WHEN skill_level = 2 AND trust_level = 2 THEN 40  -- Growing User: Middle ground
            WHEN skill_level = 2 AND trust_level = 3 THEN 30  -- Eager Adopter
            WHEN skill_level = 3 AND trust_level = 1 THEN 40  -- Cautious Expert
            WHEN skill_level = 3 AND trust_level = 2 THEN 20  -- Balanced Expert
            WHEN skill_level = 3 AND trust_level = 3 THEN 10  -- AI Champion: Minimal buffer
            ELSE 50
        END
    ) STORED,

    -- History tracking
    previous_skill_level INT,
    previous_trust_level INT,
    level_changed_at TIMESTAMP,

    -- Notes
    notes TEXT,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_skill_level CHECK (skill_level BETWEEN 1 AND 5),
    CONSTRAINT valid_trust_level CHECK (trust_level BETWEEN 1 AND 5),
    UNIQUE(user_id)
);

-- Indexes
CREATE INDEX idx_quad_adoption_matrix_user ON QUAD_adoption_matrix(user_id);
CREATE INDEX idx_quad_adoption_matrix_zone ON QUAD_adoption_matrix(zone_name);
CREATE INDEX idx_quad_adoption_matrix_levels ON QUAD_adoption_matrix(skill_level, trust_level);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_adoption_matrix_updated_at
    BEFORE UPDATE ON QUAD_adoption_matrix
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_adoption_matrix IS 'Tracks user position on Skill × Trust matrix for AI adoption. Determines safety buffer percentages.';
COMMENT ON COLUMN QUAD_adoption_matrix.safety_buffer_pct IS 'Buffer added to AI estimates. 80% for skeptics → 10% for champions.';
