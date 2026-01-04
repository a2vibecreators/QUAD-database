-- QUAD_pull_requests Table
-- Pull requests tracked from Git providers
--
-- Part of: QUAD Git
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_pull_requests (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    repository_id   UUID NOT NULL REFERENCES QUAD_git_repositories(id) ON DELETE CASCADE,
    ticket_id       UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,

    pr_number       INTEGER NOT NULL,
    title           VARCHAR(500),
    description     TEXT,
    source_branch   VARCHAR(255),
    target_branch   VARCHAR(255),

    author_id       UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    author_github   VARCHAR(100),

    status          VARCHAR(20) DEFAULT 'open',  -- open, merged, closed
    is_draft        BOOLEAN DEFAULT false,

    additions       INTEGER DEFAULT 0,
    deletions       INTEGER DEFAULT 0,
    changed_files   INTEGER DEFAULT 0,

    opened_at       TIMESTAMP WITH TIME ZONE,
    merged_at       TIMESTAMP WITH TIME ZONE,
    closed_at       TIMESTAMP WITH TIME ZONE,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_pull_requests IS 'Pull requests tracked from Git providers';
