-- QUAD_known_persons Table
-- Memory of people the device/agent knows
--
-- Part of: SUMA HOME / QUAD Devices
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_known_persons (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    user_id             UUID REFERENCES QUAD_users(id),        -- Owner of this memory

    -- Person identification
    name                VARCHAR(100) NOT NULL,                  -- "Ashrith"
    nickname            VARCHAR(50),                            -- "Ash"
    relationship        VARCHAR(50),                            -- friend, family, coworker, guest

    -- Greeting preferences
    greeting_language   VARCHAR(20) DEFAULT 'english',          -- english, telugu, hindi, etc.
    custom_greeting     VARCHAR(200),                           -- "ela vunnav", "how are you"
    custom_farewell     VARCHAR(200),                           -- "bye bye", "chusa mama"

    -- Voice/Face recognition (future)
    voice_signature     BYTEA,                                  -- Voice print for recognition
    face_encoding       BYTEA,                                  -- Face encoding for recognition

    -- Interaction history
    first_seen          TIMESTAMP DEFAULT NOW(),
    last_seen           TIMESTAMP,
    visit_count         INTEGER DEFAULT 1,
    total_interactions  INTEGER DEFAULT 0,

    -- Preferences
    preferred_motion    VARCHAR(50) DEFAULT 'wave',             -- wave, sit, dance
    energy_level        VARCHAR(20) DEFAULT 'normal',           -- calm, normal, excited

    -- Additional info
    notes               TEXT,                                   -- "Suman's friend, likes tech"
    metadata            JSONB DEFAULT '{}',                     -- Extra data

    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(domain_id, name)
);

-- Indexes
CREATE INDEX idx_known_persons_domain ON QUAD_known_persons(domain_id);
CREATE INDEX idx_known_persons_user ON QUAD_known_persons(user_id);
CREATE INDEX idx_known_persons_name ON QUAD_known_persons(name);
CREATE INDEX idx_known_persons_last_seen ON QUAD_known_persons(last_seen DESC);

COMMENT ON TABLE QUAD_known_persons IS 'Memory of known people for personalized interactions';
COMMENT ON COLUMN QUAD_known_persons.custom_greeting IS 'Personalized greeting in their preferred language';
