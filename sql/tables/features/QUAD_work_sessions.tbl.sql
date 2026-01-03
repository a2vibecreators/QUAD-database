-- Table: QUAD_work_sessions
-- Section: features
-- Purpose: Track daily focused work hours for 4-4-4 principle validation

CREATE TABLE QUAD_work_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

    session_date DATE NOT NULL,

    -- Time tracking
    hours_worked DECIMAL(4,2) NOT NULL DEFAULT 0,
    -- Target: 4 hours of focused work

    is_workday BOOLEAN DEFAULT true,
    -- FALSE = day off (part of 3-day weekend)

    -- Session details
    start_time TIME,
    end_time TIME,

    -- Quality indicators
    deep_work_pct DECIMAL(5,2),   -- % of time in deep focus (no interruptions)
    meeting_hours DECIMAL(4,2),   -- Time spent in meetings

    -- Notes
    notes TEXT,

    -- Metadata
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    -- Constraints
    UNIQUE(user_id, session_date)
);

-- Indexes
CREATE INDEX idx_quad_work_sessions_user ON QUAD_work_sessions(user_id);
CREATE INDEX idx_quad_work_sessions_date ON QUAD_work_sessions(session_date);
CREATE INDEX idx_quad_work_sessions_workday ON QUAD_work_sessions(is_workday);

-- Trigger for updated_at
CREATE TRIGGER trg_quad_work_sessions_updated_at
    BEFORE UPDATE ON QUAD_work_sessions
    FOR EACH ROW
    EXECUTE FUNCTION QUAD_update_updated_at_column();

-- Comments
COMMENT ON TABLE QUAD_work_sessions IS 'Daily work session tracking for 4-4-4 principle. Target: 4 focused hours per workday.';
