-- QUAD_release_contributors Table
-- Contributors to a release
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_release_contributors (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    release_id      UUID NOT NULL REFERENCES QUAD_release_notes(id) ON DELETE CASCADE,
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    contribution_type VARCHAR(50) DEFAULT 'development',  -- development, review, testing, documentation

    commits_count   INTEGER DEFAULT 0,
    lines_added     INTEGER DEFAULT 0,
    lines_removed   INTEGER DEFAULT 0,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(release_id, user_id)
);

COMMENT ON TABLE QUAD_release_contributors IS 'Contributors to a release';
