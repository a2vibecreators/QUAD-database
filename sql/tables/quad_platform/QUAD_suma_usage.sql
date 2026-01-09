-- Suma API - Usage Tracking
-- Purpose: Log every API call for billing, analytics, debugging
-- Created: January 9, 2026

CREATE TABLE IF NOT EXISTS QUAD_suma_usage (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign keys
    company_id UUID NOT NULL REFERENCES QUAD_companies(id) ON DELETE CASCADE,
    api_key_id UUID NOT NULL REFERENCES QUAD_suma_api_keys(id) ON DELETE CASCADE,

    -- Request details
    endpoint VARCHAR(100) NOT NULL, -- "/v1/chat", "/v1/code-review", "/v1/generate-agent"
    model_used VARCHAR(50), -- "claude-sonnet-4.5", "gemini-2.0-flash"

    -- Token usage
    input_tokens INT DEFAULT 0 CHECK (input_tokens >= 0),
    output_tokens INT DEFAULT 0 CHECK (output_tokens >= 0),
    total_tokens INT GENERATED ALWAYS AS (input_tokens + output_tokens) STORED,

    -- Cost tracking
    cost_usd DECIMAL(10, 6) DEFAULT 0 CHECK (cost_usd >= 0), -- Actual cost from AI provider
    charged_tokens INT DEFAULT 0 CHECK (charged_tokens >= 0), -- Tokens charged to customer

    -- Performance
    response_time_ms INT CHECK (response_time_ms >= 0),

    -- Status
    success BOOLEAN DEFAULT true,
    error_code VARCHAR(50), -- "rate_limit", "insufficient_credits", "invalid_request"
    error_message TEXT,

    -- Request metadata
    ip_address VARCHAR(45),
    user_agent TEXT,

    -- Timestamp
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_suma_usage_company ON QUAD_suma_usage(company_id);
CREATE INDEX idx_suma_usage_api_key ON QUAD_suma_usage(api_key_id);
CREATE INDEX idx_suma_usage_created_at ON QUAD_suma_usage(created_at DESC);
CREATE INDEX idx_suma_usage_endpoint ON QUAD_suma_usage(endpoint);
CREATE INDEX idx_suma_usage_success ON QUAD_suma_usage(success);

-- Partitioning by month (for large-scale data)
-- Note: Enable partitioning when usage exceeds 10M rows
-- CREATE TABLE QUAD_suma_usage_2026_01 PARTITION OF QUAD_suma_usage
--     FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

-- Comments
COMMENT ON TABLE QUAD_suma_usage IS 'Detailed usage logs for Suma API (billing, analytics, debugging)';
COMMENT ON COLUMN QUAD_suma_usage.endpoint IS 'API endpoint called (e.g., /v1/chat)';
COMMENT ON COLUMN QUAD_suma_usage.model_used IS 'AI model used for this request';
COMMENT ON COLUMN QUAD_suma_usage.cost_usd IS 'Actual cost charged by AI provider (Anthropic/Google)';
COMMENT ON COLUMN QUAD_suma_usage.charged_tokens IS 'Tokens deducted from customer balance';
COMMENT ON COLUMN QUAD_suma_usage.response_time_ms IS 'API response time in milliseconds';
