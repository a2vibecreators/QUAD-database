-- QUAD_release_notes Table
-- Release notes for deployments
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_release_notes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deployment_id   UUID NOT NULL REFERENCES QUAD_deployments(id) ON DELETE CASCADE,

    version         VARCHAR(50) NOT NULL,
    title           VARCHAR(255),
    summary         TEXT,
    changes         JSONB,  -- Array of { type, description, ticket_id }

    is_published    BOOLEAN DEFAULT false,
    published_at    TIMESTAMP WITH TIME ZONE,

    created_by      UUID REFERENCES QUAD_users(id) ON DELETE SET NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE QUAD_release_notes IS 'Release notes for deployments';
