-- Device Types Seed Data
-- Run: psql -h localhost -p 14201 -U postgres -d quad_dev_db -f seeds/device-types.sql

-- Petoi Bittle Robot Dog
INSERT INTO QUAD_device_types (
    id,
    product_name,
    product_slug,
    manufacturer,
    model_number,
    category,
    connection_type,
    protocol,
    capabilities,
    command_schema,
    blocked_commands,
    ble_service_uuid,
    ble_char_uuid,
    discovery_pattern,
    documentation_url
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'Petoi Bittle',
    'petoi-bittle',
    'Petoi LLC',
    'Bittle X',
    'robot',
    'ble',
    'opencat',
    '["move", "pose", "audio", "sense"]',
    '{
        "skills": {
            "balance": {"cmd": "kbalance", "params": null, "description": "Stand balanced"},
            "sit": {"cmd": "ksit", "params": null, "description": "Sit down"},
            "rest": {"cmd": "krest", "params": null, "description": "Rest position"},
            "walk_forward": {"cmd": "kwkF", "params": null, "description": "Walk forward"},
            "walk_left": {"cmd": "kwkL", "params": null, "description": "Walk left"},
            "walk_right": {"cmd": "kwkR", "params": null, "description": "Walk right"},
            "walk_back": {"cmd": "kwkB", "params": null, "description": "Walk backward"},
            "trot": {"cmd": "ktrF", "params": null, "description": "Trot forward"},
            "wave": {"cmd": "khi", "params": null, "description": "Wave hello"},
            "pee": {"cmd": "kpee", "params": null, "description": "Pee pose"},
            "pushup": {"cmd": "kpu", "params": null, "description": "Do pushups"},
            "dead": {"cmd": "kdead", "params": null, "description": "Play dead"}
        },
        "joints": {
            "head_pan": {"cmd": "m", "joint": 0, "min": -70, "max": 70},
            "head_tilt": {"cmd": "m", "joint": 1, "min": -30, "max": 60},
            "front_left_shoulder": {"cmd": "m", "joint": 8, "min": -50, "max": 50},
            "front_left_knee": {"cmd": "m", "joint": 9, "min": -30, "max": 90},
            "front_right_shoulder": {"cmd": "m", "joint": 10, "min": -50, "max": 50},
            "front_right_knee": {"cmd": "m", "joint": 11, "min": -30, "max": 90},
            "back_left_shoulder": {"cmd": "m", "joint": 12, "min": -50, "max": 50},
            "back_left_knee": {"cmd": "m", "joint": 13, "min": -30, "max": 90},
            "back_right_shoulder": {"cmd": "m", "joint": 14, "min": -50, "max": 50},
            "back_right_knee": {"cmd": "m", "joint": 15, "min": -30, "max": 90}
        },
        "audio": {
            "beep": {"cmd": "b", "note_min": 0, "note_max": 127, "dur_min": 1, "dur_max": 255, "max_notes": 16}
        },
        "system": {
            "query_joints": {"cmd": "j", "allowed": true},
            "pause": {"cmd": "p", "allowed": true},
            "custom_skill": {"cmd": "K", "allowed": true, "description": "Upload custom skill array"},
            "replay_skill": {"cmd": "T", "allowed": true, "description": "Replay last skill"}
        }
    }',
    '["c", "s", "a", "G", "X", "U"]',
    '0000ffe0-0000-1000-8000-00805f9b34fb',
    '0000ffe1-0000-1000-8000-00805f9b34fb',
    'Bittle.*',
    'https://docs.petoi.com/apis/serial-protocol'
) ON CONFLICT (product_slug) DO UPDATE SET
    command_schema = EXCLUDED.command_schema,
    updated_at = NOW();

-- Show registered device types
SELECT product_name, category, connection_type, protocol
FROM QUAD_device_types
ORDER BY product_name;
