-- QUAD_git_operations Table
-- Git operation audit log (commits, merges, syncs)
--
-- Part of: QUAD Git
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_git_operations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    repository_id   UUID NOT NULL REFERENCES QUAD_git_repositories(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    operation_type  VARCHAR(50) NOT NULL,  -- push, pull, merge, rebase, sync, webhook
    ref             VARCHAR(255),  -- branch or tag name
    commit_sha      VARCHAR(40),

    status          VARCHAR(20) DEFAULT 'completed',
    error_message   TEXT,

    metadata        JSONB,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_git_operations IS 'Git operation audit log (commits, merges, syncs)';
