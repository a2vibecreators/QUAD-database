-- Function: QUAD_init_company_roles
-- Purpose: Auto-create default roles when a company is created

CREATE OR REPLACE FUNCTION QUAD_init_company_roles()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO QUAD_roles (
        company_id, role_code, role_name, description,
        can_manage_company, can_manage_users, can_manage_domains,
        can_manage_flows, can_view_all_metrics, can_manage_circles, can_manage_resources,
        q_participation, u_participation, a_participation, d_participation,
        color_code, icon_name, display_order, hierarchy_level, is_system_role
    )
    VALUES
        -- Admin: Oversees all, reviews major decisions
        -- Q: INFORM (knows about requests), U: INFORM, A: REVIEW (approves allocations), D: INFORM
        (NEW.id, 'ADMIN', 'Administrator', 'Full access to all company features',
         TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
         'INFORM', 'INFORM', 'REVIEW', 'INFORM',
         '#EF4444', 'shield-check', 1, 100, TRUE),

        -- Manager: Owns Q and A stages (Product Owner / Scrum Master)
        -- Q: PRIMARY (receives requests), U: PRIMARY (clarifies requirements), A: PRIMARY (assigns work), D: REVIEW (accepts deliverables)
        (NEW.id, 'MANAGER', 'Manager', 'Manage users, domains, and flows',
         FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE,
         'PRIMARY', 'PRIMARY', 'PRIMARY', 'REVIEW',
         '#8B5CF6', 'users', 2, 80, TRUE),

        -- Tech Lead: Technical guidance and review
        -- Q: SUPPORT (helps clarify technical questions), U: PRIMARY (designs solutions), A: SUPPORT (helps estimate), D: REVIEW (code review)
        (NEW.id, 'TECH_LEAD', 'Tech Lead', 'Technical leadership and code review',
         FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE,
         'SUPPORT', 'PRIMARY', 'SUPPORT', 'REVIEW',
         '#3B82F6', 'code', 3, 60, TRUE),

        -- Developer: Core delivery
        -- Q: INFORM (gets notified), U: SUPPORT (helps analyze), A: INFORM (gets assigned), D: PRIMARY (does the work)
        (NEW.id, 'DEVELOPER', 'Developer', 'Development and implementation',
         FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
         'INFORM', 'SUPPORT', 'INFORM', 'PRIMARY',
         '#10B981', 'terminal', 4, 40, TRUE),

        -- QA: Testing and verification
        -- Q: INFORM, U: SUPPORT (helps define acceptance criteria), A: INFORM, D: REVIEW (verifies quality)
        (NEW.id, 'QA', 'QA Engineer', 'Testing and quality assurance',
         FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
         'INFORM', 'SUPPORT', 'INFORM', 'REVIEW',
         '#F59E0B', 'check-circle', 5, 40, TRUE),

        -- Observer: Read-only, just gets informed
        -- Q: INFORM, U: INFORM, A: INFORM, D: INFORM
        (NEW.id, 'OBSERVER', 'Observer', 'Read-only access to view progress',
         FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE,
         'INFORM', 'INFORM', 'INFORM', 'INFORM',
         '#6B7280', 'eye', 6, 20, TRUE)

    ON CONFLICT (company_id, role_code) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_companies_init_roles
    AFTER INSERT ON QUAD_companies
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_init_company_roles();

COMMENT ON FUNCTION QUAD_init_company_roles() IS 'Auto-creates default roles (ADMIN, MANAGER, TECH_LEAD, DEVELOPER, QA, OBSERVER) when company is created.';
