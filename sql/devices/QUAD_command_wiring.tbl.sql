-- QUAD_command_wiring Table
-- Maps natural language → categories → device commands
--
-- Part of: SUMA WIRE / QUAD Devices
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_command_wiring (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_type_id      UUID REFERENCES QUAD_device_types(id) ON DELETE CASCADE,

    -- Category hierarchy
    category            VARCHAR(50) NOT NULL,           -- movement, tricks, audio, social, system
    subcategory         VARCHAR(50),                    -- walk, greet, respond, etc.

    -- Command identification
    command_name        VARCHAR(100) NOT NULL,          -- "greet_person"
    command_description TEXT,                           -- "Greet a known person with wave + speech"

    -- Natural language triggers (what user might say)
    trigger_phrases     JSONB DEFAULT '[]',             -- ["hello", "hi", "hey", "{name} is here"]

    -- Action sequence (multiple commands in order)
    action_sequence     JSONB NOT NULL,                 -- [{type: "motion", cmd: "khi"}, {type: "speech", text: "..."}]

    -- Parameters
    required_params     JSONB DEFAULT '[]',             -- ["person_name"]
    optional_params     JSONB DEFAULT '[]',             -- ["greeting_language"]

    -- Context requirements
    requires_person     BOOLEAN DEFAULT false,          -- Needs person lookup from memory
    requires_device     BOOLEAN DEFAULT true,           -- Needs device connection

    -- Response template
    response_template   TEXT,                           -- "hello {name} {greeting}"

    -- Metadata
    priority            INTEGER DEFAULT 50,             -- Higher = matched first
    enabled             BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_command_wiring_device ON QUAD_command_wiring(device_type_id);
CREATE INDEX idx_command_wiring_category ON QUAD_command_wiring(category);
CREATE INDEX idx_command_wiring_name ON QUAD_command_wiring(command_name);
CREATE INDEX idx_command_wiring_triggers ON QUAD_command_wiring USING GIN (trigger_phrases);

COMMENT ON TABLE QUAD_command_wiring IS 'SUMA WIRE - Maps natural language to device command sequences';
COMMENT ON COLUMN QUAD_command_wiring.action_sequence IS 'Ordered list of actions: motion, speech, api_call, wait';
