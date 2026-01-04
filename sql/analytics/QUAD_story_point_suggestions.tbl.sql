-- QUAD_story_point_suggestions Table
-- AI story point suggestions
-- Part of: QUAD Analytics | Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_story_point_suggestions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_id UUID NOT NULL REFERENCES QUAD_tickets(id) ON DELETE CASCADE,
    suggested_points INTEGER, confidence NUMERIC(3,2),
    reasoning TEXT, similar_tickets JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE QUAD_story_point_suggestions IS 'AI story point suggestions';
