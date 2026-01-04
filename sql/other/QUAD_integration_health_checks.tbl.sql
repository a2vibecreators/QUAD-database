-- QUAD_integration_health_checks Table
-- Health check results for integrations
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_integration_health_checks (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    integration_type VARCHAR(50) NOT NULL,  -- github, slack, jira
    integration_id  UUID,

    status          VARCHAR(20) NOT NULL,  -- healthy, degraded, unhealthy
    response_time_ms INTEGER,
    error_message   TEXT,

    checked_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_integration_health_checks IS 'Health check results for integrations';
