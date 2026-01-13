-- QUAD_device_commands Table
-- Command history and audit log for device interactions
--
-- Part of: SUMA HOME / QUAD Devices
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_device_commands (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id           UUID NOT NULL REFERENCES QUAD_devices(id) ON DELETE CASCADE,
    user_id             UUID REFERENCES QUAD_users(id),

    -- Command details
    command_type        VARCHAR(50) NOT NULL,           -- skill, joint, audio, system, custom
    command_raw         VARCHAR(500) NOT NULL,          -- Raw command: "kwkF", "m 0 45"
    command_natural     VARCHAR(500),                   -- Natural language: "walk forward"

    -- Validation
    was_validated       BOOLEAN DEFAULT true,
    validation_result   VARCHAR(20),                    -- approved, blocked, modified
    validation_reason   TEXT,                           -- Why blocked/modified

    -- Execution
    status              VARCHAR(20) DEFAULT 'pending',  -- pending, sent, success, failed
    sent_at             TIMESTAMP,
    response            TEXT,
    error_message       TEXT,

    -- Source
    source              VARCHAR(50) DEFAULT 'user',     -- user, agent, schedule, automation
    agent_id            UUID,                           -- If sent by QUAD agent
    automation_id       UUID,                           -- If sent by automation

    created_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_device_commands_device ON QUAD_device_commands(device_id);
CREATE INDEX idx_device_commands_user ON QUAD_device_commands(user_id);
CREATE INDEX idx_device_commands_status ON QUAD_device_commands(status);
CREATE INDEX idx_device_commands_created ON QUAD_device_commands(created_at DESC);
CREATE INDEX idx_device_commands_type ON QUAD_device_commands(command_type);

COMMENT ON TABLE QUAD_device_commands IS 'Audit log of all device commands';
COMMENT ON COLUMN QUAD_device_commands.validation_result IS 'QUAD safety validation result';
