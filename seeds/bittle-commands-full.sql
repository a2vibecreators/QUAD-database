-- Full Bittle Command Wiring (English Only)
-- All Petoi Bittle skills mapped to QUAD
-- Run: psql -h localhost -p 14201 -U quad_user -d quad_dev_db -f seeds/bittle-commands-full.sql

-- Bittle Device Type ID
-- b1771e00-0000-0000-0000-000000000001

-- Clear existing
DELETE FROM QUAD_command_wiring WHERE device_type_id = 'b1771e00-0000-0000-0000-000000000001';

-- ============================================
-- POSTURES (Static poses)
-- ============================================

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'posture', 'basic',
    'sit',
    'Sit down',
    '["sit", "sit down"]',
    '[{"type": "motion", "cmd": "ksit"}]',
    false, 60
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'posture', 'basic',
    'stand',
    'Stand up / balance',
    '["stand", "stand up", "balance"]',
    '[{"type": "motion", "cmd": "kbalance"}]',
    false, 60
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'posture', 'basic',
    'rest',
    'Lie down / rest',
    '["rest", "lie down", "sleep"]',
    '[{"type": "motion", "cmd": "krest"}]',
    false, 60
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'posture', 'basic',
    'stretch',
    'Stretch body',
    '["stretch"]',
    '[{"type": "motion", "cmd": "kstr"}]',
    false, 50
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'posture', 'basic',
    'butt_up',
    'Butt up pose',
    '["butt up", "booty up"]',
    '[{"type": "motion", "cmd": "kbuttUp"}]',
    false, 40
);

-- ============================================
-- MOVEMENT / GAITS
-- ============================================

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'walk',
    'walk_forward',
    'Walk forward',
    '["walk", "walk forward", "go", "move", "come here", "come"]',
    '[{"type": "motion", "cmd": "kwkF"}]',
    false, 70
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'walk',
    'walk_backward',
    'Walk backward',
    '["back", "go back", "walk back", "backward"]',
    '[{"type": "motion", "cmd": "kwkB"}]',
    false, 65
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'walk',
    'walk_left',
    'Walk/turn left',
    '["left", "go left", "turn left"]',
    '[{"type": "motion", "cmd": "kwkL"}]',
    false, 65
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'walk',
    'walk_right',
    'Walk/turn right',
    '["right", "go right", "turn right"]',
    '[{"type": "motion", "cmd": "kwkR"}]',
    false, 65
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'run',
    'trot',
    'Trot / run forward',
    '["trot", "run", "fast", "faster"]',
    '[{"type": "motion", "cmd": "ktrF"}]',
    false, 65
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'crawl',
    'crawl',
    'Crawl forward slowly',
    '["crawl", "sneak", "slow"]',
    '[{"type": "motion", "cmd": "kcrF"}]',
    false, 55
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'movement', 'stop',
    'stop',
    'Stop moving',
    '["stop", "halt", "freeze", "stay"]',
    '[{"type": "motion", "cmd": "kbalance"}]',
    false, 90
);

-- ============================================
-- TRICKS / BEHAVIORS
-- ============================================

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'greeting',
    'wave',
    'Wave hello with paw',
    '["wave", "say hi", "hello", "hi"]',
    '[{"type": "motion", "cmd": "khi"}]',
    false, 70
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'greeting',
    'handshake',
    'Shake hands',
    '["shake hands", "handshake", "paw", "give paw", "shake"]',
    '[{"type": "motion", "cmd": "kts"}]',
    false, 65
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'exercise',
    'pushup',
    'Do pushups',
    '["pushup", "push up", "pushups", "exercise"]',
    '[{"type": "motion", "cmd": "kpu"}]',
    false, 60
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'exercise',
    'pushup_one_hand',
    'One-handed pushup',
    '["one hand pushup", "single hand pushup", "one arm pushup"]',
    '[{"type": "motion", "cmd": "kpu1"}]',
    false, 55
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'acrobatic',
    'backflip',
    'Do a backflip',
    '["backflip", "back flip", "flip back", "flip"]',
    '[{"type": "motion", "cmd": "kbf"}]',
    false, 50
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'acrobatic',
    'frontflip',
    'Do a frontflip',
    '["frontflip", "front flip", "flip forward"]',
    '[{"type": "motion", "cmd": "kff"}]',
    false, 50
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'funny',
    'pee',
    'Pee / lift leg',
    '["pee", "lift leg", "bathroom"]',
    '[{"type": "motion", "cmd": "kpee"}]',
    false, 45
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'funny',
    'play_dead',
    'Play dead',
    '["play dead", "dead", "bang", "die"]',
    '[{"type": "motion", "cmd": "kpd"}]',
    false, 55
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'action',
    'sniff',
    'Sniff / check around',
    '["sniff", "smell", "check"]',
    '[{"type": "motion", "cmd": "kck"}]',
    false, 50
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'action',
    'jump',
    'Jump / joy',
    '["jump", "hop", "joy", "happy"]',
    '[{"type": "motion", "cmd": "kjy"}]',
    false, 55
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'action',
    'recover',
    'Get up / recover',
    '["get up", "recover", "rise"]',
    '[{"type": "motion", "cmd": "krc"}]',
    false, 60
);

-- ============================================
-- SOCIAL (Person interactions)
-- ============================================

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, required_params, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'social', 'greet',
    'greet_person',
    'Greet a known person with wave + speech',
    '["hello {name}", "hi {name}", "{name} is here", "hey {name}", "greet {name}"]',
    '[
        {"type": "motion", "cmd": "khi"},
        {"type": "speech", "template": "Woof woof! Hello {name}!", "delay_ms": 500}
    ]',
    '["person_name"]',
    true,
    'Woof woof! Hello {name}!',
    100
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, required_params, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'social', 'farewell',
    'farewell_person',
    'Say goodbye with wave + speech',
    '["bye {name}", "goodbye {name}", "see you {name}"]',
    '[
        {"type": "speech", "template": "Woof! Bye bye {name}!"},
        {"type": "motion", "cmd": "khi"}
    ]',
    '["person_name"]',
    true,
    'Woof! Bye bye {name}!',
    100
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, required_params, requires_person, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'social', 'approach',
    'walk_to_person',
    'Walk towards a person',
    '["go to {name}", "walk to {name}", "find {name}"]',
    '[
        {"type": "motion", "cmd": "kwkF", "duration_ms": 2000},
        {"type": "motion", "cmd": "kbalance"}
    ]',
    '["person_name"]',
    true,
    80
);

-- ============================================
-- COMPOUND ACTIONS
-- ============================================

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'perform',
    'show_off',
    'Show off with multiple tricks',
    '["show off", "do tricks", "impress", "perform", "do a trick"]',
    '[
        {"type": "speech", "template": "Woof! Watch this!"},
        {"type": "motion", "cmd": "khi"},
        {"type": "wait", "duration_ms": 1000},
        {"type": "motion", "cmd": "kpu"},
        {"type": "wait", "duration_ms": 1500},
        {"type": "motion", "cmd": "kbalance"},
        {"type": "speech", "template": "Ta-da! Woof woof!"}
    ]',
    false,
    'Ta-da! Woof woof!',
    70
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'tricks', 'perform',
    'dance',
    'Do a little dance',
    '["dance", "do a dance"]',
    '[
        {"type": "speech", "template": "Woof! Dance time!"},
        {"type": "motion", "cmd": "kwkL"},
        {"type": "wait", "duration_ms": 500},
        {"type": "motion", "cmd": "kwkR"},
        {"type": "wait", "duration_ms": 500},
        {"type": "motion", "cmd": "kjy"},
        {"type": "wait", "duration_ms": 500},
        {"type": "motion", "cmd": "kbalance"}
    ]',
    false,
    'That was fun! Woof!',
    60
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'response', 'acknowledge',
    'good_boy',
    'Respond happily to praise',
    '["good boy", "good dog", "well done", "nice", "great", "awesome"]',
    '[
        {"type": "motion", "cmd": "kjy"},
        {"type": "speech", "template": "Woof woof! Thank you!"}
    ]',
    false,
    'Woof woof! Thank you!',
    50
);

INSERT INTO QUAD_command_wiring (
    device_type_id, category, subcategory, command_name, command_description,
    trigger_phrases, action_sequence, requires_person, response_template, priority
) VALUES (
    'b1771e00-0000-0000-0000-000000000001',
    'response', 'confused',
    'confused',
    'Express confusion',
    '["what", "huh", "confused"]',
    '[
        {"type": "motion", "cmd": "kck"},
        {"type": "speech", "template": "Woof? I do not understand."}
    ]',
    false,
    'Woof? I do not understand.',
    30
);

-- ============================================
-- Show summary
-- ============================================
SELECT category, count(*) as commands
FROM QUAD_command_wiring
WHERE device_type_id = 'b1771e00-0000-0000-0000-000000000001'
GROUP BY category
ORDER BY commands DESC;
