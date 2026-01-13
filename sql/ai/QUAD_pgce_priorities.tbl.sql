-- QUAD_pgce_priorities Table
-- Stores PGCE (Priority-Guided Code Evolution) calculations
--
-- Part of: QUAD AI / PGCE Engine
-- Created: January 2026
-- Patent: 63/957,663 - Priority-Guided Code Evolution Algorithm
--
-- Formula: P = (D × 0.5) + (I × 0.3) + (C' × 0.2)
-- Where:
--   D = Dependency Score (how many features depend on this)
--   I = Impact Score (business value / user benefit)
--   C' = Inverted Complexity (1 - complexity, simpler = higher score)
--   P = Final Priority Score (0.00 - 1.00)

CREATE TABLE IF NOT EXISTS QUAD_pgce_priorities (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    project_id      UUID REFERENCES QUAD_projects(id) ON DELETE CASCADE,
    ticket_id       UUID REFERENCES QUAD_tickets(id) ON DELETE SET NULL,

    -- Feature identification
    feature_name    VARCHAR(200) NOT NULL,
    feature_type    VARCHAR(50),          -- feature, bugfix, refactor, enhancement
    feature_hash    VARCHAR(64),          -- Hash for deduplication

    -- PGCE Scores (0.00 - 1.00)
    dependency_score    DECIMAL(4,3) NOT NULL DEFAULT 0.500,
    impact_score        DECIMAL(4,3) NOT NULL DEFAULT 0.500,
    complexity_score    DECIMAL(4,3) NOT NULL DEFAULT 0.500,  -- Raw complexity
    complexity_inverted DECIMAL(4,3) GENERATED ALWAYS AS (1 - complexity_score) STORED,  -- C'

    -- Final Priority: P = (D × 0.5) + (I × 0.3) + (C' × 0.2)
    priority_score      DECIMAL(4,3) GENERATED ALWAYS AS (
        (dependency_score * 0.5) +
        (impact_score * 0.3) +
        ((1 - complexity_score) * 0.2)
    ) STORED,

    -- Dependency analysis
    depends_on          JSONB DEFAULT '[]',           -- Feature IDs this depends on
    dependents          JSONB DEFAULT '[]',           -- Feature IDs that depend on this
    dependency_graph    JSONB,                        -- Full dependency tree

    -- Build order (calculated from dependencies)
    build_order         INTEGER,                      -- 1 = first, 2 = second, etc.
    build_layer         VARCHAR(50),                  -- database, api, service, ui

    -- Code patterns matched
    matched_patterns    UUID[],                       -- References to QUAD_code_patterns
    pattern_match_score DECIMAL(4,3) DEFAULT 0.000,   -- Average pattern match (0.00 - 1.00)

    -- AST analysis results
    ast_analysis        JSONB,                        -- Detailed AST comparison
    ast_complexity      INTEGER,                      -- Number of AST nodes

    -- RAG context
    rag_context         JSONB,                        -- Retrieved context from vector search
    rag_relevance_score DECIMAL(4,3),                 -- How relevant was retrieved context

    -- Calculation metadata
    calculated_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    calculation_version VARCHAR(20) DEFAULT '1.0.0',
    calculation_time_ms INTEGER,                      -- How long calculation took

    -- Execution tracking
    status              VARCHAR(20) DEFAULT 'pending',  -- pending, in_progress, completed, failed
    started_at          TIMESTAMP WITH TIME ZONE,
    completed_at        TIMESTAMP WITH TIME ZONE,
    error_message       TEXT,

    -- Generated artifacts
    generated_code_hash VARCHAR(64),
    generated_files     JSONB DEFAULT '[]',           -- List of generated file paths
    pr_number           INTEGER,                      -- GitHub PR number if created
    pr_url              TEXT,

    -- Validation results
    validation_status   VARCHAR(20) DEFAULT 'pending',  -- pending, passed, failed
    validation_score    DECIMAL(4,3),                   -- Final validation score
    validation_details  JSONB,                          -- Detailed validation breakdown

    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by          UUID REFERENCES QUAD_users(id),

    UNIQUE(domain_id, project_id, feature_hash)
);

-- Indexes for PGCE queries
CREATE INDEX idx_pgce_priority_score ON QUAD_pgce_priorities(priority_score DESC);
CREATE INDEX idx_pgce_build_order ON QUAD_pgce_priorities(build_order);
CREATE INDEX idx_pgce_build_layer ON QUAD_pgce_priorities(build_layer);
CREATE INDEX idx_pgce_status ON QUAD_pgce_priorities(status);
CREATE INDEX idx_pgce_validation ON QUAD_pgce_priorities(validation_status);
CREATE INDEX idx_pgce_project ON QUAD_pgce_priorities(project_id);
CREATE INDEX idx_pgce_domain ON QUAD_pgce_priorities(domain_id);
CREATE INDEX idx_pgce_calculated ON QUAD_pgce_priorities(calculated_at DESC);

-- GIN indexes for JSONB columns
CREATE INDEX idx_pgce_depends_on ON QUAD_pgce_priorities USING GIN (depends_on);
CREATE INDEX idx_pgce_matched_patterns ON QUAD_pgce_priorities USING GIN (matched_patterns);
CREATE INDEX idx_pgce_rag_context ON QUAD_pgce_priorities USING GIN (rag_context);

-- Trigger to update timestamp
CREATE OR REPLACE FUNCTION update_pgce_priorities_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_pgce_priorities_timestamp
    BEFORE UPDATE ON QUAD_pgce_priorities
    FOR EACH ROW
    EXECUTE FUNCTION update_pgce_priorities_timestamp();

-- Function to recalculate build order based on dependencies
CREATE OR REPLACE FUNCTION calculate_build_order(p_project_id UUID)
RETURNS VOID AS $$
DECLARE
    rec RECORD;
    current_order INTEGER := 1;
    processed_ids UUID[] := '{}';
BEGIN
    -- Reset build orders
    UPDATE QUAD_pgce_priorities SET build_order = NULL WHERE project_id = p_project_id;

    -- Iteratively assign build order
    LOOP
        -- Find features with no unprocessed dependencies
        FOR rec IN
            SELECT id
            FROM QUAD_pgce_priorities p
            WHERE p.project_id = p_project_id
              AND p.build_order IS NULL
              AND NOT EXISTS (
                  SELECT 1 FROM jsonb_array_elements_text(p.depends_on) d
                  WHERE d::UUID != ALL(processed_ids)
              )
        LOOP
            UPDATE QUAD_pgce_priorities
            SET build_order = current_order
            WHERE id = rec.id;

            processed_ids := array_append(processed_ids, rec.id);
        END LOOP;

        -- Check if we made progress
        IF NOT FOUND THEN EXIT; END IF;

        current_order := current_order + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

COMMENT ON TABLE QUAD_pgce_priorities IS 'PGCE priority calculations - Patent 63/957,663';
COMMENT ON COLUMN QUAD_pgce_priorities.priority_score IS 'P = (D × 0.5) + (I × 0.3) + (C'' × 0.2)';
COMMENT ON COLUMN QUAD_pgce_priorities.pattern_match_score IS 'Close to Zero Hallucination score (0.00-1.00)';
COMMENT ON COLUMN QUAD_pgce_priorities.build_order IS 'Dependency-ordered build sequence';
