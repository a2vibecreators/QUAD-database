-- QUAD_devices Table
-- Registered device instances (user's actual devices)
--
-- Part of: SUMA HOME / QUAD Devices
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_devices (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id           UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    user_id             UUID REFERENCES QUAD_users(id) ON DELETE CASCADE,
    device_type_id      UUID NOT NULL REFERENCES QUAD_device_types(id),

    -- Device identification
    device_name         VARCHAR(100) NOT NULL,          -- User's name: "Living Room Bittle"
    device_alias        VARCHAR(50),                    -- Short alias: "bittle1"

    -- Connection details (for reconnection)
    connection_address  VARCHAR(100),                   -- BLE: "88964021-0A54-7BA8-0AB9-A449223B7EAE"
    connection_port     VARCHAR(50),                    -- Serial: "/dev/tty.Bittle"
    mac_address         VARCHAR(20),                    -- "AA:BB:CC:DD:EE:FF"

    -- State
    status              VARCHAR(20) DEFAULT 'offline',  -- online, offline, connecting, error
    last_seen           TIMESTAMP,
    last_command        VARCHAR(100),
    last_command_at     TIMESTAMP,

    -- Location
    location            VARCHAR(100),                   -- "Living Room"
    location_coords     JSONB,                          -- {lat, lng} if applicable

    -- Device-specific config
    config              JSONB DEFAULT '{}',             -- Device-specific settings
    custom_skills       JSONB DEFAULT '[]',             -- User-created skills (like Bittle K arrays)

    -- Pairing info
    paired_at           TIMESTAMP,
    paired_by           UUID REFERENCES QUAD_users(id),
    pairing_code        VARCHAR(20),                    -- If device requires pairing code

    -- Metadata
    firmware_version    VARCHAR(20),
    battery_level       INTEGER,                        -- 0-100 if applicable
    signal_strength     INTEGER,                        -- RSSI for wireless

    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_devices_user ON QUAD_devices(user_id);
CREATE INDEX idx_devices_type ON QUAD_devices(device_type_id);
CREATE INDEX idx_devices_domain ON QUAD_devices(domain_id);
CREATE INDEX idx_devices_status ON QUAD_devices(status);
CREATE INDEX idx_devices_address ON QUAD_devices(connection_address);
CREATE INDEX idx_devices_alias ON QUAD_devices(device_alias);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_devices_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_devices_updated_at
    BEFORE UPDATE ON QUAD_devices
    FOR EACH ROW
    EXECUTE FUNCTION update_devices_timestamp();

COMMENT ON TABLE QUAD_devices IS 'User registered device instances';
COMMENT ON COLUMN QUAD_devices.connection_address IS 'BLE UUID or IP address for reconnection';
COMMENT ON COLUMN QUAD_devices.custom_skills IS 'User-created skills (Bittle K arrays, custom automations)';
