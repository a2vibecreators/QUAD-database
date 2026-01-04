-- QUAD_sandbox_instances Table
-- Tracks individual sandbox instances for dynamic scaling
--
-- Sandbox Modes:
--   Mode 1: pr_sandbox   - Created per PR, destroyed on merge (24h idle timeout)
--   Mode 2: shared       - Always running pool (min N instances)
--   Mode 3: devbox       - Per-developer on-demand
--
-- Part of: QUAD Infrastructure System
-- Created: January 3, 2026

CREATE TABLE IF NOT EXISTS QUAD_sandbox_instances (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id              UUID NOT NULL REFERENCES quad_organizations(id) ON DELETE CASCADE,
    domain_id           UUID REFERENCES quad_domains(id) ON DELETE SET NULL,

    -- ========================================================================
    -- SANDBOX MODE & STATUS
    -- ========================================================================
    mode                VARCHAR(20) NOT NULL,
    -- 'pr_sandbox' = Created for PR testing (Mode 1)
    -- 'shared'     = Part of shared pool (Mode 2)
    -- 'devbox'     = Per-developer instance (Mode 3)

    status              VARCHAR(20) NOT NULL DEFAULT 'provisioning',
    -- 'provisioning' = Being created
    -- 'running'      = Active and healthy
    -- 'idle'         = No activity for configured period
    -- 'terminating'  = Being shut down
    -- 'terminated'   = Shut down (kept for audit)
    -- 'error'        = Failed to provision or crashed

    -- ========================================================================
    -- ACTIVITY TRACKING (for idle detection & auto-scale)
    -- ========================================================================
    last_activity_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    activity_count      INTEGER DEFAULT 0,          -- Total API calls/operations
    activity_count_hour INTEGER DEFAULT 0,          -- API calls in last hour (reset hourly)
    idle_since          TIMESTAMP WITH TIME ZONE,   -- When it became idle (NULL if active)

    -- ========================================================================
    -- PR SANDBOX (Mode 1)
    -- ========================================================================
    pr_id               UUID,  -- REFERENCES QUAD_pull_requests(id)
    pr_number           INTEGER,
    pr_branch           VARCHAR(255),
    merge_on_close      BOOLEAN DEFAULT true,       -- Auto-terminate when PR merged/closed

    -- ========================================================================
    -- DEVBOX (Mode 3)
    -- ========================================================================
    assigned_user_id    UUID REFERENCES quad_users(id) ON DELETE SET NULL,
    assigned_user_email VARCHAR(255),

    -- ========================================================================
    -- CLOUD RESOURCES
    -- ========================================================================
    cloud_provider      VARCHAR(20) NOT NULL DEFAULT 'gcp',
    -- 'gcp', 'aws', 'azure', 'local'

    cloud_region        VARCHAR(50),
    cloud_zone          VARCHAR(50),
    cloud_instance_id   VARCHAR(255),               -- Provider's instance ID
    cloud_instance_type VARCHAR(50),                -- e.g., 'e2-medium', 't3.small'
    cloud_ip_internal   VARCHAR(50),
    cloud_ip_external   VARCHAR(50),

    -- Kubernetes (if using k8s)
    k8s_namespace       VARCHAR(100),
    k8s_pod_name        VARCHAR(255),
    k8s_service_url     VARCHAR(500),

    -- ========================================================================
    -- RESOURCE ALLOCATION
    -- ========================================================================
    cpu_cores           DECIMAL(4,2) DEFAULT 1.0,   -- vCPUs allocated
    memory_mb           INTEGER DEFAULT 2048,        -- RAM in MB
    disk_gb             INTEGER DEFAULT 20,          -- Disk in GB
    gpu_enabled         BOOLEAN DEFAULT false,

    -- ========================================================================
    -- COST TRACKING
    -- ========================================================================
    hourly_cost_usd     DECIMAL(10,4),              -- Estimated hourly cost
    total_cost_usd      DECIMAL(10,2) DEFAULT 0,    -- Running total
    billable_hours      DECIMAL(10,2) DEFAULT 0,

    -- ========================================================================
    -- LIFECYCLE TIMESTAMPS
    -- ========================================================================
    requested_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    provisioned_at      TIMESTAMP WITH TIME ZONE,   -- When ready to use
    terminated_at       TIMESTAMP WITH TIME ZONE,
    termination_reason  VARCHAR(100),
    -- 'idle_timeout', 'pr_merged', 'pr_closed', 'manual', 'budget_exceeded', 'error'

    -- ========================================================================
    -- METADATA
    -- ========================================================================
    created_by          UUID REFERENCES quad_users(id),
    terminated_by       UUID REFERENCES quad_users(id),
    tags                JSONB DEFAULT '{}',         -- Custom tags for filtering
    metadata            JSONB DEFAULT '{}',         -- Provider-specific metadata

    created_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Primary lookups
CREATE INDEX IF NOT EXISTS idx_sandbox_org ON QUAD_sandbox_instances(org_id);
CREATE INDEX IF NOT EXISTS idx_sandbox_domain ON QUAD_sandbox_instances(domain_id);
CREATE INDEX IF NOT EXISTS idx_sandbox_status ON QUAD_sandbox_instances(status);
CREATE INDEX IF NOT EXISTS idx_sandbox_mode ON QUAD_sandbox_instances(mode);

-- Activity tracking (for auto-scale queries)
CREATE INDEX IF NOT EXISTS idx_sandbox_last_activity ON QUAD_sandbox_instances(last_activity_at);
CREATE INDEX IF NOT EXISTS idx_sandbox_idle_since ON QUAD_sandbox_instances(idle_since) WHERE idle_since IS NOT NULL;

-- PR sandbox lookups
CREATE INDEX IF NOT EXISTS idx_sandbox_pr ON QUAD_sandbox_instances(pr_id) WHERE pr_id IS NOT NULL;

-- Devbox lookups
CREATE INDEX IF NOT EXISTS idx_sandbox_user ON QUAD_sandbox_instances(assigned_user_id) WHERE assigned_user_id IS NOT NULL;

-- Cloud resource lookups
CREATE INDEX IF NOT EXISTS idx_sandbox_cloud_instance ON QUAD_sandbox_instances(cloud_provider, cloud_instance_id);

-- Composite: Find idle sandboxes above pool minimum
CREATE INDEX IF NOT EXISTS idx_sandbox_scaling ON QUAD_sandbox_instances(org_id, mode, status, idle_since);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

CREATE OR REPLACE FUNCTION update_sandbox_instance_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;

    -- Auto-set idle_since when status changes to 'idle'
    IF NEW.status = 'idle' AND (OLD.status IS NULL OR OLD.status != 'idle') THEN
        NEW.idle_since = CURRENT_TIMESTAMP;
    ELSIF NEW.status != 'idle' THEN
        NEW.idle_since = NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sandbox_instance_updated ON QUAD_sandbox_instances;
CREATE TRIGGER trg_sandbox_instance_updated
    BEFORE UPDATE ON QUAD_sandbox_instances
    FOR EACH ROW
    EXECUTE FUNCTION update_sandbox_instance_timestamp();

-- ============================================================================
-- CONSTRAINTS
-- ============================================================================

ALTER TABLE QUAD_sandbox_instances
    ADD CONSTRAINT chk_sandbox_mode
    CHECK (mode IN ('pr_sandbox', 'shared', 'devbox'));

ALTER TABLE QUAD_sandbox_instances
    ADD CONSTRAINT chk_sandbox_status
    CHECK (status IN ('provisioning', 'running', 'idle', 'terminating', 'terminated', 'error'));

ALTER TABLE QUAD_sandbox_instances
    ADD CONSTRAINT chk_sandbox_cloud_provider
    CHECK (cloud_provider IN ('gcp', 'aws', 'azure', 'local'));

-- PR sandbox must have pr_id
ALTER TABLE QUAD_sandbox_instances
    ADD CONSTRAINT chk_pr_sandbox_has_pr
    CHECK (mode != 'pr_sandbox' OR pr_id IS NOT NULL);

-- Devbox must have assigned user
ALTER TABLE QUAD_sandbox_instances
    ADD CONSTRAINT chk_devbox_has_user
    CHECK (mode != 'devbox' OR assigned_user_id IS NOT NULL);

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON TABLE QUAD_sandbox_instances IS 'Individual sandbox instances with activity tracking for auto-scaling';
COMMENT ON COLUMN QUAD_sandbox_instances.mode IS 'pr_sandbox (Mode 1), shared (Mode 2), or devbox (Mode 3)';
COMMENT ON COLUMN QUAD_sandbox_instances.last_activity_at IS 'Last API call or operation - used for idle detection';
COMMENT ON COLUMN QUAD_sandbox_instances.idle_since IS 'When sandbox became idle - NULL if active';
COMMENT ON COLUMN QUAD_sandbox_instances.termination_reason IS 'Why sandbox was terminated: idle_timeout, pr_merged, manual, etc.';
