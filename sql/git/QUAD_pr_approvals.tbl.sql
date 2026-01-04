-- QUAD_pr_approvals Table
-- PR approval history
--
-- Part of: QUAD Git
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_pr_approvals (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pr_id           UUID NOT NULL REFERENCES QUAD_pull_requests(id) ON DELETE CASCADE,
    reviewer_id     UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    action          VARCHAR(20) NOT NULL,  -- approved, changes_requested, commented, dismissed
    comment         TEXT,

    github_review_id BIGINT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_pr_approvals IS 'PR approval history';
