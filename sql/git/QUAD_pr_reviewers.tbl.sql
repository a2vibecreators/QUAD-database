-- QUAD_pr_reviewers Table
-- Reviewers assigned to pull requests
--
-- Part of: QUAD Git
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_pr_reviewers (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pr_id           UUID NOT NULL REFERENCES QUAD_pull_requests(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    github_username VARCHAR(100),

    review_status   VARCHAR(20) DEFAULT 'pending',  -- pending, approved, changes_requested, commented
    reviewed_at     TIMESTAMP WITH TIME ZONE,

    is_required     BOOLEAN DEFAULT false,
    is_ai_suggested BOOLEAN DEFAULT false,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(pr_id, user_id)
);

COMMENT ON TABLE QUAD_pr_reviewers IS 'Reviewers assigned to pull requests';
