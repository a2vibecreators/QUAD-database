-- QUAD_code_patterns Table
-- Stores reusable code patterns for Close to Zero Hallucination
--
-- Part of: QUAD AI / PGCE Engine
-- Created: January 2026
--
-- Purpose: Store code templates and AST signatures to ensure generated
--          code matches existing patterns (98%+ pattern match rate)

CREATE TABLE IF NOT EXISTS QUAD_code_patterns (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID REFERENCES QUAD_domains(id) ON DELETE CASCADE,
    project_id      UUID REFERENCES QUAD_projects(id) ON DELETE CASCADE,

    -- Pattern identification
    pattern_type    VARCHAR(50) NOT NULL,  -- component, api, schema, util, hook
    pattern_name    VARCHAR(100) NOT NULL,
    pattern_category VARCHAR(50),          -- auth, form, table, crud, etc.

    -- Code template
    code_template   TEXT NOT NULL,
    language        VARCHAR(20) DEFAULT 'typescript',  -- typescript, javascript, sql, etc.
    framework       VARCHAR(50),                        -- nextjs, express, react, etc.

    -- AST (Abstract Syntax Tree) signature for pattern matching
    ast_signature   JSONB NOT NULL,
    ast_hash        VARCHAR(64),  -- SHA-256 hash for quick matching

    -- Metadata
    file_path       TEXT,         -- Original file path
    line_start      INTEGER,
    line_end        INTEGER,

    -- Usage tracking
    usage_count     INTEGER DEFAULT 0,
    last_used_at    TIMESTAMP WITH TIME ZONE,
    match_score_avg DECIMAL(3,2) DEFAULT 0.00,  -- Average pattern match score

    -- Pattern relationships
    depends_on      UUID[],       -- Other pattern IDs this depends on
    related_patterns UUID[],      -- Similar patterns

    -- Quality metrics
    complexity_score DECIMAL(3,2) DEFAULT 0.50,
    maintainability_score DECIMAL(3,2) DEFAULT 0.50,

    -- Status
    status          VARCHAR(20) DEFAULT 'active',  -- active, deprecated, archived
    verified_at     TIMESTAMP WITH TIME ZONE,
    verified_by     UUID REFERENCES QUAD_users(id),

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by      UUID REFERENCES QUAD_users(id),

    UNIQUE(domain_id, project_id, pattern_type, pattern_name)
);

-- Indexes for fast pattern lookup
CREATE INDEX idx_code_patterns_type ON QUAD_code_patterns(pattern_type);
CREATE INDEX idx_code_patterns_category ON QUAD_code_patterns(pattern_category);
CREATE INDEX idx_code_patterns_language ON QUAD_code_patterns(language);
CREATE INDEX idx_code_patterns_framework ON QUAD_code_patterns(framework);
CREATE INDEX idx_code_patterns_hash ON QUAD_code_patterns(ast_hash);
CREATE INDEX idx_code_patterns_usage ON QUAD_code_patterns(usage_count DESC);
CREATE INDEX idx_code_patterns_status ON QUAD_code_patterns(status);

-- GIN index for JSONB AST signature search
CREATE INDEX idx_code_patterns_ast ON QUAD_code_patterns USING GIN (ast_signature);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_code_patterns_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_code_patterns_timestamp
    BEFORE UPDATE ON QUAD_code_patterns
    FOR EACH ROW
    EXECUTE FUNCTION update_code_patterns_timestamp();

COMMENT ON TABLE QUAD_code_patterns IS 'Stores reusable code patterns for Close to Zero Hallucination code generation';
COMMENT ON COLUMN QUAD_code_patterns.pattern_type IS 'Type: component, api, schema, util, hook';
COMMENT ON COLUMN QUAD_code_patterns.ast_signature IS 'Abstract Syntax Tree structure for pattern matching';
COMMENT ON COLUMN QUAD_code_patterns.match_score_avg IS 'Average pattern match score (0.00-1.00)';
