-- QUAD_file_imports Table
-- File import history
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_file_imports (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    file_name       VARCHAR(255) NOT NULL,
    file_type       VARCHAR(50),  -- csv, json, jira_export, github_issues
    file_size_bytes INTEGER,

    import_type     VARCHAR(50) NOT NULL,  -- tickets, users, projects
    status          VARCHAR(20) DEFAULT 'pending',  -- pending, processing, completed, failed

    records_total   INTEGER DEFAULT 0,
    records_success INTEGER DEFAULT 0,
    records_failed  INTEGER DEFAULT 0,

    error_log       JSONB,

    started_at      TIMESTAMP WITH TIME ZONE,
    completed_at    TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_file_imports IS 'File import history';
