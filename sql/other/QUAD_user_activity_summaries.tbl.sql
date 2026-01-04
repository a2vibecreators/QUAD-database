-- QUAD_user_activity_summaries Table
-- Daily/weekly user activity summaries
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_user_activity_summaries (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    period_date     DATE NOT NULL,
    period_type     VARCHAR(20) DEFAULT 'daily',  -- daily, weekly

    tickets_created INTEGER DEFAULT 0,
    tickets_completed INTEGER DEFAULT 0,
    commits_pushed  INTEGER DEFAULT 0,
    prs_opened      INTEGER DEFAULT 0,
    prs_reviewed    INTEGER DEFAULT 0,
    comments_made   INTEGER DEFAULT 0,
    ai_requests     INTEGER DEFAULT 0,

    active_hours    NUMERIC(4,2) DEFAULT 0,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(user_id, period_date, period_type)
);

COMMENT ON TABLE QUAD_user_activity_summaries IS 'Daily/weekly user activity summaries';
