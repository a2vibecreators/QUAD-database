-- ============================================================================
-- Migration 010: Ticket Attributes System
-- ============================================================================
-- Flexible attribute system for tickets
-- Allows configuration of estimated time for regular dev, complexity, and custom attributes
-- Plugin & play architecture - attributes can be extended per organization
-- Created: January 16, 2026

BEGIN;

-- ============================================================================
-- 1. ATTRIBUTE DEFINITIONS (What attributes exist)
-- ============================================================================

-- Define what attributes are available (organization-scoped for plugin & play)
CREATE TABLE IF NOT EXISTS QUAD_attribute_definitions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id     UUID NOT NULL REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    -- Attribute metadata
    attribute_key       VARCHAR(100) NOT NULL,      -- 'regular_dev_hours', 'skill_required', 'risk_level'
    attribute_name      VARCHAR(255) NOT NULL,      -- 'Regular Developer Hours', 'Skill Required Level'
    description         TEXT,
    attribute_type      VARCHAR(50) NOT NULL,       -- 'numeric', 'enum', 'text', 'boolean'

    -- For numeric attributes
    min_value           NUMERIC(10, 2),
    max_value           NUMERIC(10, 2),
    unit                VARCHAR(50),                -- 'hours', 'percentage', 'score'

    -- For enum attributes
    enum_values         TEXT[],                     -- ['easy', 'medium', 'hard'] stored as array

    -- Weight in fairness calculation (if applicable)
    fairness_weight     NUMERIC(3, 2) DEFAULT 0,   -- 0-1.0, sum of all should = 1.0 or 0 if not used

    -- System vs custom
    is_system           BOOLEAN DEFAULT false,      -- System attributes: estimated_hours, complexity, priority
    is_required         BOOLEAN DEFAULT true,

    -- Status
    is_active           BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(organization_id, attribute_key)
);

CREATE INDEX idx_attr_def_org ON QUAD_attribute_definitions(organization_id);
CREATE INDEX idx_attr_def_key ON QUAD_attribute_definitions(attribute_key);

COMMENT ON TABLE QUAD_attribute_definitions IS
'Define what attributes are available for tickets. Organization-scoped for plugin & play.
Example:
- regular_dev_hours: How long would a regular developer take? (numeric, hours)
- skill_required: What skill level is needed? (enum: junior/mid/senior)
- risk_level: Risk assessment (enum: low/medium/high)
- domain_familiarity: How familiar is user with this domain? (numeric, 0-100%)';

-- ============================================================================
-- 2. ATTRIBUTE VALUES (Value of each attribute per ticket)
-- ============================================================================

-- Store actual attribute values for each ticket
CREATE TABLE IF NOT EXISTS QUAD_ticket_attributes (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id           UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    attribute_def_id    UUID NOT NULL REFERENCES QUAD_attribute_definitions(id) ON DELETE CASCADE,

    -- The actual value (flexible storage)
    value_numeric       NUMERIC(15, 4),             -- For numeric attributes
    value_enum          VARCHAR(100),               -- For enum attributes
    value_text          TEXT,                       -- For text attributes
    value_boolean       BOOLEAN,                    -- For boolean attributes

    -- Metadata
    set_by              UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE SET NULL,
    set_at              TIMESTAMP DEFAULT NOW(),
    reason              TEXT,                       -- Why was this value set?

    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW(),

    UNIQUE(ticket_id, attribute_def_id)
);

CREATE INDEX idx_ticket_attrs_ticket ON QUAD_ticket_attributes(ticket_id);
CREATE INDEX idx_ticket_attrs_def ON QUAD_ticket_attributes(attribute_def_id);

COMMENT ON TABLE QUAD_ticket_attributes IS
'Store actual attribute values for each ticket.
Example row:
- ticket_id: ticket-123
- attribute_def_id: regular_dev_hours definition
- value_numeric: 20
- set_by: user-456
- reason: "Estimated based on similar auth tickets"';

-- ============================================================================
-- 3. ATTRIBUTE HISTORY (Audit trail of attribute changes)
-- ============================================================================

CREATE TABLE IF NOT EXISTS QUAD_ticket_attribute_history (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id           UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    attribute_def_id    UUID NOT NULL REFERENCES QUAD_attribute_definitions(id) ON DELETE CASCADE,

    -- The change
    old_value           TEXT,                       -- JSON stringified for all types
    new_value           TEXT,                       -- JSON stringified
    changed_by          UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE SET NULL,
    change_reason       TEXT,

    created_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_attr_history_ticket ON QUAD_ticket_attribute_history(ticket_id);
CREATE INDEX idx_attr_history_date ON QUAD_ticket_attribute_history(created_at);

COMMENT ON TABLE QUAD_ticket_attribute_history IS 'Immutable audit trail of all attribute changes for compliance';

-- ============================================================================
-- 4. STANDARD ATTRIBUTES (Seed data for all organizations)
-- ============================================================================

-- Function to create standard attributes for an organization
CREATE OR REPLACE FUNCTION create_standard_attributes(org_id UUID)
RETURNS void AS $$
BEGIN
    INSERT INTO QUAD_attribute_definitions (
        organization_id, attribute_key, attribute_name, description,
        attribute_type, min_value, max_value, unit,
        fairness_weight, is_system, is_required
    ) VALUES
    -- Estimated hours for regular developer (key attribute!)
    (org_id, 'regular_dev_hours', 'Regular Developer Hours',
     'How long would a mid-level developer typically take on this task?',
     'numeric', 0.5, 1000, 'hours', 0.20, true, true),

    -- Complexity
    (org_id, 'complexity', 'Task Complexity',
     'Complexity level: easy (1-2h), medium (3-8h), hard (8+ hours)',
     'enum', NULL, NULL, NULL, 0.20, true, true),

    -- Skill level required
    (org_id, 'skill_required', 'Required Skill Level',
     'What skill level is needed to complete this?',
     'enum', NULL, NULL, NULL, 0.10, false, false),

    -- Domain familiarity (user assessment)
    (org_id, 'domain_familiarity', 'User Domain Familiarity',
     'User familiarity with this domain (0-100%)',
     'numeric', 0, 100, 'percentage', 0.15, false, false),

    -- Risk level
    (org_id, 'risk_level', 'Technical Risk',
     'Risk assessment: low (known patterns), medium (some unknowns), high (experimental)',
     'enum', NULL, NULL, NULL, 0.10, false, false),

    -- Blockers/dependencies
    (org_id, 'has_blockers', 'Has Blockers',
     'Does this ticket have external blockers/dependencies?',
     'boolean', NULL, NULL, NULL, 0.05, false, false),

    -- Estimated time (existing - for reference)
    (org_id, 'estimated_hours', 'Estimated Hours',
     'Original estimate in hours (from QUAD_tickets.estimated_hours)',
     'numeric', 0.5, 1000, 'hours', 0.20, true, true)
    ON CONFLICT (organization_id, attribute_key) DO NOTHING;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION create_standard_attributes IS
'Initialize standard attributes for an organization. Called on org creation.
Standard attributes cover: regular_dev_hours, complexity, skill_required, domain_familiarity, risk_level, blockers, estimated_hours';

-- ============================================================================
-- 5. VIEWS FOR TICKET ATTRIBUTES
-- ============================================================================

-- View: Ticket attributes with definitions (human-readable)
CREATE OR REPLACE VIEW v_ticket_attributes_detailed AS
SELECT
    ta.ticket_id,
    ta.attribute_def_id,
    ad.attribute_key,
    ad.attribute_name,
    ad.attribute_type,
    ad.unit,
    COALESCE(ta.value_numeric::text, ta.value_enum, ta.value_text, ta.value_boolean::text) as value,
    ta.value_numeric,
    ta.value_enum,
    ad.fairness_weight,
    ta.set_by,
    ta.set_at,
    ta.reason
FROM QUAD_ticket_attributes ta
JOIN QUAD_attribute_definitions ad ON ta.attribute_def_id = ad.id
ORDER BY ta.ticket_id, ad.attribute_key;

COMMENT ON VIEW v_ticket_attributes_detailed IS
'Ticket attributes with full definitions. Use this to display attributes in UI.
Shows: ticket_id, attribute_name, value, unit, fairness_weight, who set it and when';

-- View: Attribute impact on fairness
CREATE OR REPLACE VIEW v_attribute_fairness_weights AS
SELECT
    attribute_key,
    attribute_name,
    fairness_weight,
    unit,
    CASE
        WHEN fairness_weight > 0 THEN 'Affects fairness calculation'
        ELSE 'Informational only'
    END as impact,
    MIN(min_value::text) as min_value,
    MAX(max_value::text) as max_value
FROM QUAD_attribute_definitions
WHERE is_active = true
GROUP BY attribute_key, attribute_name, fairness_weight, unit
ORDER BY fairness_weight DESC;

COMMENT ON VIEW v_attribute_fairness_weights IS
'Shows which attributes affect fairness and their weights.
Example: regular_dev_hours (0.20), complexity (0.20), domain_familiarity (0.15), etc.';

-- ============================================================================
-- 6. EXAMPLE QUERY: Compare user time vs regular dev time
-- ============================================================================

-- Example usage query (not a view, just documentation):
-- SELECT
--     t.id as ticket_id,
--     t.title,
--     COALESCE(
--         (SELECT ta.value_numeric FROM QUAD_ticket_attributes ta
--          JOIN QUAD_attribute_definitions ad ON ta.attribute_def_id = ad.id
--          WHERE ta.ticket_id = t.id AND ad.attribute_key = 'regular_dev_hours'),
--         20  -- Default estimate if not set
--     ) as regular_dev_hours,
--     COALESCE(
--         SUM(tl.hours_worked), 0
--     ) as user_actual_hours,
--     ROUND(
--         (SELECT ta.value_numeric FROM QUAD_ticket_attributes ta
--          JOIN QUAD_attribute_definitions ad ON ta.attribute_def_id = ad.id
--          WHERE ta.ticket_id = t.id AND ad.attribute_key = 'regular_dev_hours')
--         / NULLIF(SUM(tl.hours_worked), 0), 2
--     ) as efficiency_ratio
-- FROM QUAD_tickets t
-- LEFT JOIN QUAD_time_logs tl ON t.id = tl.ticket_id
-- WHERE t.domain_id = (SELECT id FROM QUAD_domains WHERE name = 'QUAD Core')
-- GROUP BY t.id, t.title
-- ORDER BY efficiency_ratio DESC;

-- ============================================================================
-- 7. UPDATED FAIRNESS CALCULATION WITH ATTRIBUTES
-- ============================================================================

-- Note: Update FairnessService to use attributes
-- Pseudo-code for fairness calculation:
-- 1. Get all active attributes with fairness_weight > 0
-- 2. For each attribute, calculate component score (0-100)
-- 3. Apply weights: SUM(component_score × weight)
-- 4. Example attributes affecting fairness:
--    - regular_dev_hours: Compare user_hours vs regular_hours (efficiency)
--    - domain_familiarity: Adjust expectations based on user skill
--    - risk_level: Adjust for experimental work

COMMENT ON SCHEMA public IS
'Fairness now considers multiple attributes:
1. Regular developer baseline (expected hours)
2. User actual hours (from time logs)
3. Domain familiarity (user skill in this domain)
4. Risk level (experimental vs known patterns)
5. Skill level required (junior/mid/senior task)
6. Blockers (external dependencies)

Fairness calculation:
  FAIRNESS = SUM(attribute_score × attribute_weight)
  where attribute_weight comes from QUAD_attribute_definitions.fairness_weight
  and sum of all weights = 1.0 (or 0 if not used)';

COMMIT;

-- ============================================================================
-- MIGRATION GUIDE
-- ============================================================================
-- To use this system:
--
-- 1. Run this migration:
--    psql -U postgres -d quad_dev -f sql/010_ticket_attributes_system.sql
--
-- 2. For each organization, initialize standard attributes:
--    SELECT create_standard_attributes('org-id-here');
--
-- 3. Set ticket attributes via API/UI:
--    INSERT INTO QUAD_ticket_attributes (ticket_id, attribute_def_id, value_numeric, set_by)
--    SELECT t.id, ad.id, 20, 'user-id'
--    FROM QUAD_tickets t, QUAD_attribute_definitions ad
--    WHERE t.id = 'ticket-123' AND ad.attribute_key = 'regular_dev_hours';
--
-- 4. View ticket attributes:
--    SELECT * FROM v_ticket_attributes_detailed WHERE ticket_id = 'ticket-123';
--
-- 5. Update FairnessService to calculate using:
--    - regular_dev_hours vs actual hours (efficiency component)
--    - domain_familiarity adjustment
--    - risk_level adjustment
--    - skill_required as context for expectations
