-- QUAD_api_request_logs Table
-- API request audit log
--
-- Part of: QUAD Other
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_api_request_logs (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    api_config_id   UUID REFERENCES QUAD_api_access_config(id) ON DELETE SET NULL,

    method          VARCHAR(10) NOT NULL,
    path            VARCHAR(500) NOT NULL,
    status_code     INTEGER,
    response_time_ms INTEGER,

    ip_address      VARCHAR(50),
    user_agent      TEXT,

    error_message   TEXT,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_QUAD_api_request_logs_config ON QUAD_api_request_logs(api_config_id);
CREATE INDEX IF NOT EXISTS idx_QUAD_api_request_logs_created ON QUAD_api_request_logs(created_at);

COMMENT ON TABLE QUAD_api_request_logs IS 'API request audit log';
