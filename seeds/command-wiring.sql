-- Command Wiring Seed Data
-- SUMA WIRE mappings for Petoi Bittle
-- Run: psql -h localhost -p 14201 -U postgres -d quad_dev_db -f seeds/command-wiring.sql

-- Bittle Device Type ID
-- b1771e00-0000-0000-0000-000000000001

-- Category: SOCIAL (person interactions)
INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, required_params, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'social', 'greet',
    'greet_person',
    'Greet a known person with wave + personalized speech',
    '["hello {name}", "hi {name}", "{name} is here", "hey {name}", "{name} vachadu", "{name} vachindi"]',
    '[
        {"type": "motion", "cmd": "khi", "description": "Wave hello"},
        {"type": "speech", "template": "hello {name} {greeting}", "delay_ms": 500}
    ]',
    '["person_name"]',
    true,
    'hello {name} {custom_greeting}',
    100
) ON CONFLICT DO NOTHING;

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, required_params, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'social', 'farewell',
    'farewell_person',
    'Say goodbye to a person with wave + speech',
    '["bye {name}", "goodbye {name}", "{name} velthunadu", "see you {name}"]',
    '[
        {"type": "speech", "template": "bye bye {name} {farewell}"},
        {"type": "motion", "cmd": "khi", "description": "Wave goodbye"}
    ]',
    '["person_name"]',
    true,
    'bye bye {name} {custom_farewell}',
    100
) ON CONFLICT DO NOTHING;

-- Category: MOVEMENT
INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'walk',
    'walk_forward',
    'Walk forward',
    '["walk", "walk forward", "go", "move", "come here", "ikkadiki ra"]',
    '[{"type": "motion", "cmd": "kwkF"}]',
    false,
    50
) ON CONFLICT DO NOTHING;

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'walk',
    'walk_to_person',
    'Walk towards a person',
    '["go to {name}", "walk to {name}", "{name} daggariki vellu"]',
    '[
        {"type": "motion", "cmd": "kwkF", "duration_ms": 2000},
        {"type": "motion", "cmd": "kbalance"}
    ]',
    true,
    80
) ON CONFLICT DO NOTHING;

-- Category: TRICKS
INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'perform',
    'do_trick',
    'Perform a trick and announce it',
    '["do a trick", "show off", "impress {name}", "trick cheyyi"]',
    '[
        {"type": "speech", "template": "watch this!"},
        {"type": "motion", "cmd": "kpu", "description": "Pushup"},
        {"type": "motion", "cmd": "kbalance", "delay_ms": 2000}
    ]',
    false,
    50
) ON CONFLICT DO NOTHING;

-- Category: RESPONSES (for conversations)
INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'response', 'acknowledge',
    'acknowledge_person',
    'Acknowledge what someone said',
    '["good boy", "nice", "well done", "manchi pani", "bagundi"]',
    '[
        {"type": "motion", "cmd": "ksit", "description": "Sit happily"},
        {"type": "speech", "template": "thank you {name}!"}
    ]',
    false,
    40
) ON CONFLICT DO NOTHING;

-- Seed some known persons for demo
INSERT INTO QUAD_known_persons (
    name, nickname, relationship, greeting_language, custom_greeting, custom_farewell,
    preferred_motion, notes
) VALUES
    ('Ashrith', 'Ash', 'friend', 'telugu', 'ela vunnav', 'malli kaluddham', 'wave', 'Tech friend'),
    ('Suman', 'macha', 'owner', 'telugu', 'namaskaram boss', 'bye boss', 'wave', 'Owner of Bittle'),
    ('Guest', NULL, 'guest', 'english', 'nice to meet you', 'goodbye', 'wave', 'Default for unknown')
ON CONFLICT DO NOTHING;

-- Show wiring
SELECT category, subcategory, command_name, trigger_phrases::text
FROM QUAD_command_wiring
WHERE device_type_id = 'b1771e00-0000-0000-0000-000000000001'
ORDER BY category, priority DESC;
