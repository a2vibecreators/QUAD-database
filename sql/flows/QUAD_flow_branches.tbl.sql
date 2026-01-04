-- QUAD_flow_branches Table
-- Git branches associated with flows
--
-- Part of: QUAD Flows
-- Created: January 2026

CREATE TABLE IF NOT EXISTS QUAD_flow_branches (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    flow_id         UUID NOT NULL REFERENCES QUAD_flows(id) ON DELETE CASCADE,
    repository_id   UUID REFERENCES QUAD_git_repositories(id) ON DELETE SET NULL,

    branch_name     VARCHAR(255) NOT NULL,
    is_primary      BOOLEAN DEFAULT false,

    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(flow_id, repository_id, branch_name)
);

COMMENT ON TABLE QUAD_flow_branches IS 'Git branches associated with flows';
