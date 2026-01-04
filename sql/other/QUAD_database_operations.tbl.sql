-- QUAD_database_operations Table
-- Database operation audit log
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_database_operations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    connection_id   UUID NOT NULL REFERENCES QUAD_database_connections(id) ON DELETE CASCADE,
    user_id         UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,

    operation_type  VARCHAR(20) NOT NULL,  -- query, script, migration
    query           TEXT,
    query_hash      VARCHAR(64),

    status          VARCHAR(20) DEFAULT 'completed',
    rows_affected   INTEGER,
    execution_ms    INTEGER,
    error_message   TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_database_operations IS 'Database operation audit log';
