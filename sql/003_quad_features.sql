-- ============================================================================
-- QUAD Features Schema: Adoption Matrix, Workload Tracking, Flows
-- Date: January 1, 2026
-- Purpose: Support 4-4-4 Principle, Adoption Matrix, and Workload Tracking
-- ============================================================================

-- ============================================================================
-- TABLE 1: QUAD_adoption_matrix
-- ============================================================================
-- Purpose: Track each user's position on the Skill × Trust matrix
-- The matrix determines safety buffer percentages for AI estimates

CREATE TABLE IF NOT EXISTS QUAD_adoption_matrix (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

  -- 3×3 Matrix Position (can extend to 5×5 later)
  skill_level INT NOT NULL DEFAULT 1,
  -- 1 = Beginner, 2 = Intermediate, 3 = Expert

  trust_level INT NOT NULL DEFAULT 1,
  -- 1 = Low Trust, 2 = Medium Trust, 3 = High Trust

  -- Calculated zone name based on position
  zone_name VARCHAR(50) GENERATED ALWAYS AS (
    CASE
      WHEN skill_level = 1 AND trust_level = 1 THEN 'AI Skeptic'
      WHEN skill_level = 1 AND trust_level = 2 THEN 'Curious Novice'
      WHEN skill_level = 1 AND trust_level = 3 THEN 'Trusting Novice'
      WHEN skill_level = 2 AND trust_level = 1 THEN 'Skeptical User'
      WHEN skill_level = 2 AND trust_level = 2 THEN 'Growing User'
      WHEN skill_level = 2 AND trust_level = 3 THEN 'Eager Adopter'
      WHEN skill_level = 3 AND trust_level = 1 THEN 'Cautious Expert'
      WHEN skill_level = 3 AND trust_level = 2 THEN 'Balanced Expert'
      WHEN skill_level = 3 AND trust_level = 3 THEN 'AI Champion'
      ELSE 'Unknown'
    END
  ) STORED,

  -- Safety buffer percentage (decreases as trust increases)
  safety_buffer_pct INT GENERATED ALWAYS AS (
    CASE
      WHEN skill_level = 1 AND trust_level = 1 THEN 80  -- AI Skeptic: Maximum buffer
      WHEN skill_level = 1 AND trust_level = 2 THEN 60  -- Curious Novice
      WHEN skill_level = 1 AND trust_level = 3 THEN 50  -- Trusting Novice
      WHEN skill_level = 2 AND trust_level = 1 THEN 60  -- Skeptical User
      WHEN skill_level = 2 AND trust_level = 2 THEN 40  -- Growing User: Middle ground
      WHEN skill_level = 2 AND trust_level = 3 THEN 30  -- Eager Adopter
      WHEN skill_level = 3 AND trust_level = 1 THEN 40  -- Cautious Expert
      WHEN skill_level = 3 AND trust_level = 2 THEN 20  -- Balanced Expert
      WHEN skill_level = 3 AND trust_level = 3 THEN 10  -- AI Champion: Minimal buffer
      ELSE 50
    END
  ) STORED,

  -- History tracking
  previous_skill_level INT,
  previous_trust_level INT,
  level_changed_at TIMESTAMP,

  -- Metadata
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_skill_level CHECK (skill_level BETWEEN 1 AND 5),
  CONSTRAINT valid_trust_level CHECK (trust_level BETWEEN 1 AND 5),
  UNIQUE(user_id)  -- One position per user
);

CREATE INDEX idx_adoption_matrix_user ON QUAD_adoption_matrix(user_id);
CREATE INDEX idx_adoption_matrix_zone ON QUAD_adoption_matrix(zone_name);
CREATE INDEX idx_adoption_matrix_levels ON QUAD_adoption_matrix(skill_level, trust_level);

CREATE TRIGGER trg_adoption_matrix_updated_at
  BEFORE UPDATE ON QUAD_adoption_matrix
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE QUAD_adoption_matrix IS 'Tracks user position on Skill × Trust matrix for AI adoption. Determines safety buffer percentages.';
COMMENT ON COLUMN QUAD_adoption_matrix.safety_buffer_pct IS 'Buffer added to AI estimates. 80% for skeptics → 10% for champions.';

-- ============================================================================
-- TABLE 2: QUAD_workload_metrics
-- ============================================================================
-- Purpose: Track Assignments vs Completes vs Output per user per period
-- Enables root cause analysis when gaps are detected

CREATE TABLE IF NOT EXISTS QUAD_workload_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
  domain_id UUID REFERENCES QUAD_domains(id) ON DELETE SET NULL,

  -- Time period
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  period_type VARCHAR(20) DEFAULT 'week',
  -- 'day', 'week', 'sprint', 'month'

  -- Core metrics (the 3 pillars)
  assignments INT DEFAULT 0,      -- Tasks assigned to user
  completes INT DEFAULT 0,        -- Tasks completed by user
  output_score DECIMAL(5,2),      -- Quality/productivity rating (0-100)

  -- Derived metrics
  completion_rate DECIMAL(5,2) GENERATED ALWAYS AS (
    CASE WHEN assignments > 0 THEN (completes::DECIMAL / assignments) * 100 ELSE 0 END
  ) STORED,

  -- 4-4-4 Principle tracking
  hours_worked DECIMAL(5,2) DEFAULT 0,    -- Actual hours worked
  target_hours DECIMAL(5,2) DEFAULT 16,   -- Target: 4 hrs × 4 days = 16
  days_worked INT DEFAULT 0,              -- Actual days
  target_days INT DEFAULT 4,              -- Target: 4 days

  -- Efficiency calculation
  efficiency_multiplier DECIMAL(5,2) GENERATED ALWAYS AS (
    CASE WHEN hours_worked > 0 THEN output_score / (hours_worked / 4) ELSE 0 END
  ) STORED,
  -- If output_score = 100 and hours_worked = 16, efficiency = 100 / 4 = 25 (baseline)
  -- If output_score = 100 and hours_worked = 8, efficiency = 100 / 2 = 50 (2x efficient)

  -- Root cause analysis (when completion_rate < 80%)
  root_cause VARCHAR(50),
  -- 'SKILL_GAP', 'OVERLOAD', 'BLOCKER', 'SCOPE_CREEP', 'EXTERNAL_DEPENDENCY', 'PERSONAL'

  root_cause_notes TEXT,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_period CHECK (period_end >= period_start),
  CONSTRAINT valid_assignments CHECK (assignments >= 0),
  CONSTRAINT valid_completes CHECK (completes >= 0),
  UNIQUE(user_id, domain_id, period_start, period_end)
);

CREATE INDEX idx_workload_user ON QUAD_workload_metrics(user_id);
CREATE INDEX idx_workload_domain ON QUAD_workload_metrics(domain_id);
CREATE INDEX idx_workload_period ON QUAD_workload_metrics(period_start, period_end);
CREATE INDEX idx_workload_root_cause ON QUAD_workload_metrics(root_cause);

CREATE TRIGGER trg_workload_metrics_updated_at
  BEFORE UPDATE ON QUAD_workload_metrics
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE QUAD_workload_metrics IS 'Tracks Assignments vs Completes vs Output. Enables 4-4-4 principle validation and root cause analysis.';
COMMENT ON COLUMN QUAD_workload_metrics.root_cause IS 'When completion_rate < 80%, identifies why: SKILL_GAP, OVERLOAD, BLOCKER, SCOPE_CREEP, etc.';

-- ============================================================================
-- TABLE 3: QUAD_flows
-- ============================================================================
-- Purpose: Track Q-U-A-D workflow items (Question → Understand → Allocate → Deliver)

CREATE TABLE IF NOT EXISTS QUAD_flows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

  -- Flow identification
  title VARCHAR(500) NOT NULL,
  description TEXT,
  flow_type VARCHAR(50) DEFAULT 'feature',
  -- 'feature', 'bug', 'task', 'story', 'epic', 'spike'

  -- Q-U-A-D Stage tracking
  quad_stage VARCHAR(1) NOT NULL DEFAULT 'Q',
  -- 'Q' = Question, 'U' = Understand, 'A' = Allocate, 'D' = Deliver

  stage_status VARCHAR(20) DEFAULT 'pending',
  -- 'pending', 'in_progress', 'completed', 'blocked'

  -- Stage timestamps
  question_started_at TIMESTAMP,
  question_completed_at TIMESTAMP,
  understand_started_at TIMESTAMP,
  understand_completed_at TIMESTAMP,
  allocate_started_at TIMESTAMP,
  allocate_completed_at TIMESTAMP,
  deliver_started_at TIMESTAMP,
  deliver_completed_at TIMESTAMP,

  -- Assignment
  assigned_to UUID REFERENCES QUAD_users(id),
  circle_number INT,
  -- 1 = Management, 2 = Development, 3 = QA, 4 = Infrastructure

  -- Priority and estimation
  priority VARCHAR(20) DEFAULT 'medium',
  -- 'critical', 'high', 'medium', 'low'

  ai_estimate_hours DECIMAL(5,2),        -- AI's raw estimate
  buffer_pct INT,                        -- Buffer from user's adoption matrix
  final_estimate_hours DECIMAL(5,2) GENERATED ALWAYS AS (
    ai_estimate_hours * (1 + COALESCE(buffer_pct, 40)::DECIMAL / 100)
  ) STORED,
  actual_hours DECIMAL(5,2),             -- Actual time spent

  -- External integration
  external_id VARCHAR(100),              -- Jira ticket ID, GitHub issue, etc.
  external_url TEXT,

  -- Metadata
  created_by UUID REFERENCES QUAD_users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_flows_domain ON QUAD_flows(domain_id);
CREATE INDEX idx_flows_stage ON QUAD_flows(quad_stage);
CREATE INDEX idx_flows_status ON QUAD_flows(stage_status);
CREATE INDEX idx_flows_assigned ON QUAD_flows(assigned_to);
CREATE INDEX idx_flows_circle ON QUAD_flows(circle_number);
CREATE INDEX idx_flows_priority ON QUAD_flows(priority);
CREATE INDEX idx_flows_external ON QUAD_flows(external_id);

CREATE TRIGGER trg_flows_updated_at
  BEFORE UPDATE ON QUAD_flows
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE QUAD_flows IS 'Q-U-A-D workflow items. Tracks progression through Question → Understand → Allocate → Deliver stages.';
COMMENT ON COLUMN QUAD_flows.buffer_pct IS 'Safety buffer from user adoption matrix. Applied to AI estimate.';

-- ============================================================================
-- TABLE 4: QUAD_flow_stage_history
-- ============================================================================
-- Purpose: Audit trail of stage transitions

CREATE TABLE IF NOT EXISTS QUAD_flow_stage_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  flow_id UUID NOT NULL REFERENCES QUAD_flows(id) ON DELETE CASCADE,

  from_stage VARCHAR(1),           -- NULL for initial creation
  to_stage VARCHAR(1) NOT NULL,
  from_status VARCHAR(20),
  to_status VARCHAR(20) NOT NULL,

  changed_by UUID REFERENCES QUAD_users(id),
  change_reason TEXT,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_flow_history_flow ON QUAD_flow_stage_history(flow_id);
CREATE INDEX idx_flow_history_stage ON QUAD_flow_stage_history(to_stage);

COMMENT ON TABLE QUAD_flow_stage_history IS 'Audit trail tracking all Q-U-A-D stage transitions.';

-- ============================================================================
-- TABLE 5: QUAD_work_sessions
-- ============================================================================
-- Purpose: Track daily focused work hours for 4-4-4 principle validation

CREATE TABLE IF NOT EXISTS QUAD_work_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

  session_date DATE NOT NULL,

  -- Time tracking
  hours_worked DECIMAL(4,2) NOT NULL DEFAULT 0,
  -- Target: 4 hours of focused work

  is_workday BOOLEAN DEFAULT true,
  -- FALSE = day off (part of 3-day weekend)

  -- Session details
  start_time TIME,
  end_time TIME,

  -- Quality indicators
  deep_work_pct DECIMAL(5,2),   -- % of time in deep focus (no interruptions)
  meeting_hours DECIMAL(4,2),   -- Time spent in meetings

  -- Notes
  notes TEXT,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(user_id, session_date)
);

CREATE INDEX idx_work_sessions_user ON QUAD_work_sessions(user_id);
CREATE INDEX idx_work_sessions_date ON QUAD_work_sessions(session_date);
CREATE INDEX idx_work_sessions_workday ON QUAD_work_sessions(is_workday);

CREATE TRIGGER trg_work_sessions_updated_at
  BEFORE UPDATE ON QUAD_work_sessions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE QUAD_work_sessions IS 'Daily work session tracking for 4-4-4 principle. Target: 4 focused hours per workday.';

-- ============================================================================
-- TABLE 6: QUAD_circles
-- ============================================================================
-- Purpose: The 4 functional circles per domain

CREATE TABLE IF NOT EXISTS QUAD_circles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  domain_id UUID NOT NULL REFERENCES QUAD_domains(id) ON DELETE CASCADE,

  circle_number INT NOT NULL,
  -- 1 = Management, 2 = Development, 3 = QA, 4 = Infrastructure

  circle_name VARCHAR(100) NOT NULL,
  -- Default names: 'Management', 'Development', 'QA', 'Infrastructure'

  description TEXT,

  -- Circle lead
  lead_user_id UUID REFERENCES QUAD_users(id),

  -- Settings
  is_active BOOLEAN DEFAULT true,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(domain_id, circle_number)
);

CREATE INDEX idx_circles_domain ON QUAD_circles(domain_id);
CREATE INDEX idx_circles_lead ON QUAD_circles(lead_user_id);

CREATE TRIGGER trg_circles_updated_at
  BEFORE UPDATE ON QUAD_circles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE QUAD_circles IS 'The 4 functional circles per domain: Management, Development, QA, Infrastructure.';

-- ============================================================================
-- TABLE 7: QUAD_circle_members
-- ============================================================================
-- Purpose: User membership in circles

CREATE TABLE IF NOT EXISTS QUAD_circle_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id UUID NOT NULL REFERENCES QUAD_circles(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

  role VARCHAR(50) DEFAULT 'member',
  -- 'lead', 'member', 'observer'

  allocation_pct INT DEFAULT 100,
  -- How much of user's domain time is in this circle

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(circle_id, user_id)
);

CREATE INDEX idx_circle_members_circle ON QUAD_circle_members(circle_id);
CREATE INDEX idx_circle_members_user ON QUAD_circle_members(user_id);

CREATE TRIGGER trg_circle_members_updated_at
  BEFORE UPDATE ON QUAD_circle_members
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE QUAD_circle_members IS 'User membership in circles with role and allocation percentage.';

-- ============================================================================
-- VIEW: QUAD_user_dashboard
-- ============================================================================
-- Purpose: Aggregate user stats for dashboard display

CREATE OR REPLACE VIEW QUAD_user_dashboard AS
SELECT
  u.id AS user_id,
  u.full_name,
  u.email,
  c.name AS company_name,

  -- Adoption Matrix
  am.skill_level,
  am.trust_level,
  am.zone_name,
  am.safety_buffer_pct,

  -- Latest Workload (this week)
  wm.assignments AS current_assignments,
  wm.completes AS current_completes,
  wm.completion_rate AS current_completion_rate,
  wm.root_cause AS current_root_cause,

  -- 4-4-4 Stats (this week)
  wm.hours_worked AS week_hours,
  wm.days_worked AS week_days,
  wm.efficiency_multiplier,

  -- Overall stats
  (SELECT COUNT(*) FROM QUAD_flows f WHERE f.assigned_to = u.id AND f.stage_status = 'in_progress') AS active_flows,
  (SELECT COUNT(*) FROM QUAD_flows f WHERE f.assigned_to = u.id AND f.stage_status = 'completed') AS completed_flows

FROM QUAD_users u
JOIN QUAD_companies c ON c.id = u.company_id
LEFT JOIN QUAD_adoption_matrix am ON am.user_id = u.id
LEFT JOIN QUAD_workload_metrics wm ON wm.user_id = u.id
  AND wm.period_start <= CURRENT_DATE
  AND wm.period_end >= CURRENT_DATE;

COMMENT ON VIEW QUAD_user_dashboard IS 'Aggregated user stats for dashboard: adoption matrix position, current workload, 4-4-4 metrics.';

-- ============================================================================
-- FUNCTION: Initialize user adoption matrix
-- ============================================================================
-- Auto-create adoption matrix entry when user is created

CREATE OR REPLACE FUNCTION init_user_adoption_matrix()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO QUAD_adoption_matrix (user_id, skill_level, trust_level)
  VALUES (NEW.id, 1, 1)  -- Start as "AI Skeptic"
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_init_adoption_matrix
  AFTER INSERT ON QUAD_users
  FOR EACH ROW
  EXECUTE FUNCTION init_user_adoption_matrix();

-- ============================================================================
-- FUNCTION: Initialize domain circles
-- ============================================================================
-- Auto-create 4 circles when domain is created

CREATE OR REPLACE FUNCTION init_domain_circles()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO QUAD_circles (domain_id, circle_number, circle_name, description)
  VALUES
    (NEW.id, 1, 'Management', 'Circle 1: Project management, requirements, stakeholder communication'),
    (NEW.id, 2, 'Development', 'Circle 2: Design, coding, code review, architecture'),
    (NEW.id, 3, 'QA', 'Circle 3: Testing, quality assurance, bug verification'),
    (NEW.id, 4, 'Infrastructure', 'Circle 4: DevOps, deployment, monitoring, security')
  ON CONFLICT (domain_id, circle_number) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_domains_init_circles
  AFTER INSERT ON QUAD_domains
  FOR EACH ROW
  EXECUTE FUNCTION init_domain_circles();

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
