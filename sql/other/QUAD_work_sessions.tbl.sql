-- QUAD_work_sessions Table
-- Daily work sessions for time tracking
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS quad_work_sessions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES quad_users(id) ON DELETE CASCADE,
    session_date    DATE NOT NULL,
    hours_worked    NUMERIC(4,2) DEFAULT 0 NOT NULL,
    is_workday      BOOLEAN DEFAULT true,
    start_time      TIME,
    end_time        TIME,
    deep_work_pct   NUMERIC(5,2),  -- Percentage of focused work
    meeting_hours   NUMERIC(4,2) DEFAULT 0,
    notes           TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),

    UNIQUE(user_id, session_date)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_quad_work_sessions_user ON quad_work_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_quad_work_sessions_date ON quad_work_sessions(session_date);

-- Comments
COMMENT ON TABLE quad_work_sessions IS 'Daily work sessions for time tracking';
