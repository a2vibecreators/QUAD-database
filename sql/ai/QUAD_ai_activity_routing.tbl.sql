-- QUAD_ai_activity_routing Table
-- Rules for routing AI requests to different providers
--
-- Part of: QUAD AI
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_ai_activity_routing (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id          UUID REFERENCES QUAD_organizations(id) ON DELETE CASCADE,

    activity_type   VARCHAR(50) NOT NULL,  -- code_review, estimation, chat, analysis
    provider        VARCHAR(20) NOT NULL,
    model           VARCHAR(100),

    priority        INTEGER DEFAULT 50,
    is_fallback     BOOLEAN DEFAULT false,
    is_active       BOOLEAN DEFAULT true,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_ai_activity_routing IS 'Rules for routing AI requests to different providers';
