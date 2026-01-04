-- QUAD_database_connections Table
-- Database connections for direct DB access
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_database_connections (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id       UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

    name            VARCHAR(100) NOT NULL,
    db_type         VARCHAR(20) NOT NULL,  -- postgresql, mysql, mongodb
    host            VARCHAR(255) NOT NULL,
    port            INTEGER,
    database_name   VARCHAR(100),

    credentials_vault_path VARCHAR(255),

    is_readonly     BOOLEAN DEFAULT true,
    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_database_connections IS 'Database connections for direct DB access';
