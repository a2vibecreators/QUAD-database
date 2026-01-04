-- QUAD_codebase_files Table
-- Indexed codebase files
--
-- Part of: QUAD Infrastructure
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_codebase_files (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    repository_id   UUID REFERENCES QUAD_git_repositories(id) ON DELETE SET NULL,

    file_path       VARCHAR(1000) NOT NULL,
    file_name       VARCHAR(255) NOT NULL,
    file_extension  VARCHAR(20),
    file_size_bytes INTEGER,

    language        VARCHAR(50),
    content_hash    VARCHAR(64),  -- SHA256

    line_count      INTEGER,
    token_count     INTEGER,

    last_modified   TIMESTAMP WITH TIME ZONE,
    is_deleted      BOOLEAN DEFAULT false,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_codebase_files IS 'Indexed codebase files';
