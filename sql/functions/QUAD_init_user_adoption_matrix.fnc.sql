-- Function: QUAD_init_user_adoption_matrix
-- Purpose: Auto-create adoption matrix entry when user is created

CREATE OR REPLACE FUNCTION QUAD_init_user_adoption_matrix()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO QUAD_adoption_matrix (user_id, skill_level, trust_level)
    VALUES (NEW.id, 1, 1)  -- Start as "AI Skeptic"
    ON CONFLICT (user_id) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_QUAD_users_init_adoption_matrix
    AFTER INSERT ON QUAD_users
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_init_user_adoption_matrix();

COMMENT ON FUNCTION QUAD_init_user_adoption_matrix() IS 'Auto-creates adoption matrix entry for new users. Starts at position (1,1) = AI Skeptic.';
