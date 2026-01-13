-- QUAD_device_types Table
-- Product/Device type definitions (e.g., Petoi Bittle, Alexa Echo)
--
-- Part of: SUMA HOME / QUAD Devices
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_device_types (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Product identification
    product_name        VARCHAR(100) NOT NULL,          -- "Petoi Bittle"
    product_slug        VARCHAR(50) NOT NULL UNIQUE,    -- "petoi-bittle"
    manufacturer        VARCHAR(100),                   -- "Petoi LLC"
    model_number        VARCHAR(50),                    -- "Bittle X"
    category            VARCHAR(50) NOT NULL,           -- robot, speaker, light, lock, sensor

    -- Connection info
    connection_type     VARCHAR(50) NOT NULL,           -- ble, wifi, usb, zigbee, zwave
    protocol            VARCHAR(50),                    -- opencat, alexa, matter, mqtt

    -- Capabilities
    capabilities        JSONB DEFAULT '[]',             -- ["move", "speak", "sense"]

    -- Command schema (like Bittle's approved commands)
    command_schema      JSONB NOT NULL DEFAULT '{}',    -- Full schema with ranges
    blocked_commands    JSONB DEFAULT '[]',             -- Commands AI cannot use

    -- Discovery
    ble_service_uuid    VARCHAR(50),                    -- BLE service UUID
    ble_char_uuid       VARCHAR(50),                    -- BLE characteristic UUID
    discovery_pattern   VARCHAR(100),                   -- Regex for device name "Bittle.*"

    -- Metadata
    icon_url            TEXT,
    documentation_url   TEXT,
    firmware_version    VARCHAR(20),

    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_device_types_slug ON QUAD_device_types(product_slug);
CREATE INDEX idx_device_types_category ON QUAD_device_types(category);
CREATE INDEX idx_device_types_connection ON QUAD_device_types(connection_type);

COMMENT ON TABLE QUAD_device_types IS 'Device/product type definitions for SUMA HOME';
COMMENT ON COLUMN QUAD_device_types.command_schema IS 'Approved commands with parameter ranges (QUAD safety)';
