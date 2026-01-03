-- Function: QUAD_init_domain_circles
-- Purpose: Auto-create 4 circles when domain is created

CREATE OR REPLACE FUNCTION QUAD_init_domain_circles()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO QUAD_circles (domain_id, circle_number, circle_name, description)
    VALUES
        (NEW.id, 1, 'Management', 'Circle 1: Project management, requirements, stakeholder communication'),
        (NEW.id, 2, 'Development', 'Circle 2: Design, coding, code review, architecture'),
        (NEW.id, 3, 'QA', 'Circle 3: Testing, quality assurance, bug verification'),
        (NEW.id, 4, 'Infrastructure', 'Circle 4: DevOps, deployment, monitoring, security')
    ON CONFLICT (domain_id, circle_number) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_QUAD_domains_init_circles
    AFTER INSERT ON QUAD_domains
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_init_domain_circles();

COMMENT ON FUNCTION QUAD_init_domain_circles() IS 'Auto-creates 4 circles (Management, Development, QA, Infrastructure) when domain is created.';
