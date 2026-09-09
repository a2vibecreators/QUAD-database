-- ============================================================================
-- Seed Data: QUAD Realistic Work Allocation with Skill-Based Weightage
-- ============================================================================
-- Based on actual Suman's allocation:
-- - 30% time: v2 Robo (automation/discussion/collaboration)
-- - 40% time: Training/Apps (skill development)
-- - 30% time: QUAD Core (current focus)
--
-- Skill levels:
-- - UI: 50% (learning phase, needs review)
-- - Backend/Middle: 100% (expert)
-- - Robo/Automation: 75% (experienced)
--
-- Created: January 16, 2026

BEGIN;

-- Get domain IDs
WITH domains AS (
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core') as quad_core_id,
    (SELECT id FROM quad_domains WHERE name = 'V2 Robo' OR name LIKE '%robo%' LIMIT 1) as robo_id,
    (SELECT id FROM quad_domains WHERE name = 'Training' OR name LIKE '%training%' LIMIT 1) as training_id
)

-- MONTH 1: Realistic Allocation
-- Total: 175 hours in month
-- QUAD Core (30%): 52.5 hours
-- Robo (30%): 52.5 hours
-- Training (40%): 70 hours

INSERT INTO QUAD_tickets (
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, created_at
)
SELECT domain_id, title, description, estimated_hours, complexity,
       priority, ticket_type, status, CURRENT_TIMESTAMP
FROM (
  -- QUAD CORE (30% = 52.5 hours)
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[QUAD 30%] FairnessService Implementation',
    'Backend service for fairness calculations: efficiency, quality, complexity, speed, AI multiplier. Skill level: 100% (expert work)',
    20::numeric, 'hard', 'high', 'task', 'in_progress'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[QUAD 30%] API Endpoints & Testing',
    'Create fairness endpoints, test integration. Skill: 100% backend expertise',
    16::numeric, 'medium', 'high', 'task', 'in_progress'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[QUAD 30%] Database Schema & Migrations',
    'Design fairness tables and migrations. Skill: 100% database expertise',
    16.5::numeric, 'medium', 'high', 'task', 'completed'

  -- TRAINING/APPS (40% = 70 hours) - Skill Development
  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Training 40%] React UI Components - Time Logging',
    'Learn React components for time tracking. Skill: 50% (learning UI). Needs review & iteration.',
    18::numeric, 'medium', 'medium', 'task', 'in_progress'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Training 40%] React UI Components - Fairness Display',
    'Build fairness visualization. Skill: 50% (building skills). Will have 1-2 reopens for refinement.',
    16::numeric, 'medium', 'medium', 'task', 'pending'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Training 40%] React Hooks & Integration',
    'Learn React Query hooks. Skill: 50% (new patterns). Lower efficiency expected.',
    14::numeric, 'medium', 'medium', 'task', 'pending'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Training 40%] Tailwind CSS & UI Polish',
    'Style components with Tailwind. Skill: 50% (first time). May take longer.',
    12::numeric, 'easy', 'low', 'task', 'pending'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Training 40%] Gemini AI Integration Study',
    'Learn & implement Gemini API. Skill: 75% (intermediate). Understanding AI integration.',
    10::numeric, 'medium', 'medium', 'task', 'pending'

  -- V2 ROBO / AUTOMATION (30% = 52.5 hours)
  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Robo 30%] Discuss & Plan Automation Features',
    'Discussion/planning for v2 robo work. Skill: 75% (experienced). Collaborative work.',
    15::numeric, 'medium', 'high', 'task', 'in_progress'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Robo 30%] Agent Framework Design',
    'Design self-healing agent system. Skill: 75% (architecture work). Discussion-heavy.',
    18::numeric, 'hard', 'high', 'task', 'pending'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Robo 30%] Automation Scripts & Tools',
    'Build helper automation scripts. Skill: 75% (good at scripting). Productivity tools.',
    12::numeric, 'medium', 'medium', 'task', 'pending'

  UNION ALL
  SELECT
    (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
    '[Robo 30%] Planning & Documentation',
    'Document robo features & workflows. Skill: 75% (experienced). Writing & analysis.',
    7.5::numeric, 'easy', 'low', 'task', 'pending'

) month1_allocation

UNION ALL

-- MONTHS 2-6: Broader Allocation Structure
SELECT
  (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
  '[Month 2] GitHub OAuth, Webhooks, Onboarding (Skills: Core 100%, Training 40%, Robo 30%)',
  'Month 2: 121 hours split 30/40/30. GitHub integration (100% skill), UI work (50% skill), discussion planning (75% skill)',
  121::numeric, 'hard', 'high', 'epic', 'pending'

UNION ALL
SELECT
  (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
  '[Month 3] Memory System & Claude Integration (Skills: Core 100%, Training 40%, Robo 30%)',
  'Month 3: 66 hours. Backend services (expert), UI components (learning), automation planning',
  66::numeric, 'hard', 'high', 'epic', 'pending'

UNION ALL
SELECT
  (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
  '[Month 4] AI Agents & Auto-Fix (Skills: Core 100%, Robo 75%)',
  'Month 4: 80 hours. Agent framework (expert), automation (experienced). Core focus.',
  80::numeric, 'hard', 'critical', 'epic', 'pending'

UNION ALL
SELECT
  (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
  '[Month 5] Scale & Polish (Skills: Core 100%, Training 40%)',
  'Month 5: 114 hours. Backend optimization (expert), UI polish (learning). Performance & UX.',
  114::numeric, 'hard', 'high', 'epic', 'pending'

UNION ALL
SELECT
  (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
  '[Month 6] Production Deployment & Launch (Skills: Core 100%)',
  'Month 6: 76 hours. DevOps, production setup, monitoring. Core expertise.',
  76::numeric, 'hard', 'critical', 'epic', 'pending';

-- Add skill level metadata to tickets
-- Note: This extends the ticket with skill tracking

COMMENT ON COLUMN QUAD_tickets.complexity IS
'Complexity (easy/medium/hard) - does NOT include skill level adjustment. See estimated_hours for skill-adjusted estimates.';

-- Create view showing skill-adjusted fairness expectations
CREATE OR REPLACE VIEW v_skill_adjusted_expectations AS
WITH ticket_skills AS (
  SELECT
    id,
    title,
    estimated_hours,
    complexity,
    CASE
      WHEN title LIKE '%UI%' OR title LIKE '%React%' OR title LIKE '%Tailwind%' THEN 50
      WHEN title LIKE '%Backend%' OR title LIKE '%Service%' OR title LIKE '%API%' THEN 100
      WHEN title LIKE '%Robo%' OR title LIKE '%Agent%' OR title LIKE '%Automation%' THEN 75
      WHEN title LIKE '%Training%' THEN 60
      ELSE 80
    END as skill_level_percent,
    CASE
      WHEN title LIKE '[QUAD%' THEN 'QUAD Core (30%)'
      WHEN title LIKE '[Training%' THEN 'Training/Apps (40%)'
      WHEN title LIKE '[Robo%' THEN 'V2 Robo (30%)'
      ELSE 'Other'
    END as allocation_category
  FROM QUAD_tickets
  WHERE domain_id = (SELECT id FROM quad_domains WHERE name = 'QUAD Core')
)
SELECT
  id,
  title,
  skill_level_percent,
  allocation_category,
  estimated_hours,
  -- For learning work (50% skill), expect 1.5x time
  -- For experienced work (100% skill), expect 1.0x time
  -- For new learning (40-60% skill), expect 1.3-1.5x time
  (estimated_hours * CASE
    WHEN skill_level_percent >= 95 THEN 1.0   -- Expert: on estimate
    WHEN skill_level_percent >= 80 THEN 1.1   -- Experienced: 10% more
    WHEN skill_level_percent >= 70 THEN 1.2   -- Good: 20% more
    WHEN skill_level_percent >= 60 THEN 1.3   -- Learning: 30% more
    ELSE 1.5                                   -- New skill: 50% more
  END) as realistic_hours,
  -- Expected fairness based on skill
  CASE
    WHEN skill_level_percent >= 95 THEN 'Expect 90-100: Expert work, high fairness'
    WHEN skill_level_percent >= 80 THEN 'Expect 80-90: Experienced, good fairness'
    WHEN skill_level_percent >= 70 THEN 'Expect 70-80: Competent, solid fairness'
    WHEN skill_level_percent >= 60 THEN 'Expect 60-75: Learning phase, acceptable'
    ELSE 'Expect 50-65: New skill, learning curve'
  END as expected_fairness_range
FROM ticket_skills
ORDER BY skill_level_percent DESC;

-- Summary stats
SELECT
  'MONTH 1 ALLOCATION' as month_allocation,
  SUM(CASE WHEN title LIKE '[QUAD%' THEN estimated_hours ELSE 0 END) as quad_core_hours,
  SUM(CASE WHEN title LIKE '[Training%' THEN estimated_hours ELSE 0 END) as training_hours,
  SUM(CASE WHEN title LIKE '[Robo%' THEN estimated_hours ELSE 0 END) as robo_hours,
  SUM(estimated_hours) as total_hours
FROM QUAD_tickets
WHERE domain_id = (SELECT id FROM quad_domains WHERE name = 'QUAD Core')
AND created_at >= CURRENT_DATE - INTERVAL '1 day';

COMMIT;

-- Print expectations
COMMENT ON TABLE QUAD_tickets IS
'QUAD Tickets with realistic allocation: 30% QUAD Core (100% skill), 40% Training (50% skill), 30% Robo (75% skill)
Expected fairness impacts:
- QUAD Core tasks: 90-100 (expert, fast, high quality)
- Training tasks: 60-75 (learning, 1.3-1.5x time, 1-2 reopens expected)
- Robo tasks: 75-85 (experienced, 1.1-1.2x time, collaborative)

Use view v_skill_adjusted_expectations for realistic timelines and fairness predictions.';
