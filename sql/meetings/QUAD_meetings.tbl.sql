-- QUAD_meetings Table
-- Meetings synced from calendar or created in QUAD
--
-- Part of: QUAD Meetings
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_meetings (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE SET NULL,

    title           VARCHAR(500) NOT NULL,
    description     TEXT,
    meeting_type    VARCHAR(50) DEFAULT 'general',  -- standup, planning, review, retro, general

    start_time      TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time        TIMESTAMP WITH TIME ZONE NOT NULL,

    -- Calendar sync
    external_id     VARCHAR(255),
    meeting_url     TEXT,

    -- AI features
    ai_summary      TEXT,
    ai_notes        TEXT,

    organizer_id    UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_meetings IS 'Meetings synced from calendar or created in QUAD';
