-- Function: QUAD_update_updated_at_column
-- Purpose: Automatically set updated_at timestamp on row updates

CREATE OR REPLACE FUNCTION QUAD_update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION QUAD_update_updated_at_column() IS 'Trigger function to auto-update updated_at timestamp.';
