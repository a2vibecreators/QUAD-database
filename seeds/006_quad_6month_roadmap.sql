-- ============================================================================
-- Seed Data: QUAD 6-Month Roadmap Tickets (ACTUAL - Not Sample Data)
-- ============================================================================
-- Real tickets from the vision + 6-month plan
-- Month 1: Detailed (175 hours)
-- Months 2-6: Broader strokes
-- Created: January 16, 2026

BEGIN;

-- First, get the QUAD domain ID (create if needed)
WITH quad_domain AS (
  INSERT INTO quad_domains (name, description)
  VALUES (
    'QUAD Core',
    'QUAD Framework - Priority-Guided Code Evolution'
  )
  ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description
  RETURNING id
)

-- Insert MONTH 1 TICKETS: QUAD Foundation (Week 1-4) - 175 hours estimated
,month1 AS (
  SELECT id as domain_id FROM quad_domain
)

INSERT INTO QUAD_tickets (
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, created_at
)
SELECT
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, CURRENT_TIMESTAMP
FROM (
  -- QUAD-001: Design & Document System
  SELECT * FROM (VALUES
    ('design_docs',
     'Design & Document Fairness System',
     'Create comprehensive design documentation for fairness formula, fairness scoring, ticket lifecycle, database schema, API specifications. Include fairness formula breakdown and examples.',
     8::numeric, 'medium', 'high', 'task', 'in_progress')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-002: Database Migrations - Fairness System
  SELECT * FROM (VALUES
    ('db_fairness',
     'Database Migrations - Fairness System Tables',
     'Create migrations for QUAD_fairness_scores, QUAD_time_logs, QUAD_ticket_reopens, QUAD_ticket_quality_ratings, QUAD_activities tables. Includes indexes and constraints.',
     12::numeric, 'medium', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-003: Database Migrations - GitHub Integration
  SELECT * FROM (VALUES
    ('db_github',
     'Database Migrations - GitHub Integration Tables',
     'Create migrations for QUAD_github_tokens, QUAD_contributions, QUAD_ai_ticket_analysis tables. Enable GitHub SSO and contribution tracking.',
     6::numeric, 'easy', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-004: Implement FairnessService
  SELECT * FROM (VALUES
    ('fairness_service',
     'Implement FairnessCalculationService',
     'Implement all fairness calculation logic: efficiency, quality, complexity, speed, AI multiplier. Include database persistence and retrieval. Support weighted average calculation and team rankings.',
     20::numeric, 'hard', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-005: Implement TimeTrackingService
  SELECT * FROM (VALUES
    ('time_service',
     'Implement TimeTrackingService',
     'Implement time logging, aggregation, statistics. Support AI usage tracking. Calculate project allocation (QUAD vs SUMA). Track activity types (coding, reviewing, discussion, planning).',
     12::numeric, 'medium', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-006: Implement TicketService
  SELECT * FROM (VALUES
    ('ticket_service',
     'Implement TicketService',
     'Implement ticket CRUD operations: create, read, update, delete. Support search, filtering by status/assignee. Track reopens and mark complete. Calculate statistics per domain.',
     16::numeric, 'medium', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-007: Create API Endpoints - Tickets
  SELECT * FROM (VALUES
    ('api_tickets',
     'Create API Endpoints - Ticket Management',
     'Implement REST endpoints: POST /api/tickets, GET /api/tickets/:id, PUT /api/tickets/:id, DELETE /api/tickets/:id, GET /api/tickets/domain/:id, POST /api/tickets/:id/complete. Include proper error handling and validation.',
     12::numeric, 'medium', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-008: Create API Endpoints - Time Tracking
  SELECT * FROM (VALUES
    ('api_timetracking',
     'Create API Endpoints - Time Tracking',
     'Implement REST endpoints: POST/GET /api/tickets/:id/time-logs, GET /api/users/:id/time-stats. Support activity type filtering and project allocation queries.',
     10::numeric, 'medium', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-009: Create API Endpoints - Fairness Scoring
  SELECT * FROM (VALUES
    ('api_fairness',
     'Create API Endpoints - Fairness Calculation',
     'Implement REST endpoints: GET /api/tickets/:id/fairness, GET /api/users/:id/fairness, GET /api/domain/:id/fairness-ranking. Return detailed breakdown with all component scores.',
     8::numeric, 'medium', 'high', 'task', 'completed')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-010: Frontend - Ticket Create Form UI
  SELECT * FROM (VALUES
    ('ui_create_form',
     'Frontend - Ticket Creation Form',
     'Build React component for creating tickets: title, description, estimated hours, complexity dropdown (easy/medium/hard), priority, project selector (QUAD/SUMA), domain selector. Include form validation and submission handling.',
     12::numeric, 'medium', 'high', 'task', 'pending')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-011: Frontend - Ticket Detail View
  SELECT * FROM (VALUES
    ('ui_detail_view',
     'Frontend - Ticket Detail View',
     'Build React component showing full ticket details: title, description, status selector, time logs display, fairness score breakdown, reopens history, comments section. Support status updates.',
     14::numeric, 'medium', 'high', 'task', 'pending')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-012: Frontend - Time Logging Widget
  SELECT * FROM (VALUES
    ('ui_time_log',
     'Frontend - Time Logging Widget',
     'Build React component for logging hours: hours input, activity type selector (coding/reviewing/discussion/planning), description text area, AI usage checkbox. Show updated total hours after submission.',
     10::numeric, 'medium', 'high', 'task', 'pending')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-013: Frontend - Fairness Score Display
  SELECT * FROM (VALUES
    ('ui_fairness_display',
     'Frontend - Fairness Score Display Component',
     'Build React component showing fairness breakdown: overall score (0-100), component scores (efficiency, quality, complexity, speed, AI), visual bars and percentages. Color-coded performance indicators.',
     10::numeric, 'medium', 'high', 'task', 'pending')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-014: Frontend - Activity Feed
  SELECT * FROM (VALUES
    ('ui_activity_feed',
     'Frontend - Activity Feed Component',
     'Build React component showing all activities: tickets, discussions, brainstorms, meetings, code reviews. Filter by type and project. Sort by date. Show hours spent and linked items.',
     12::numeric, 'medium', 'high', 'task', 'pending')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)

  UNION ALL

  -- QUAD-015: Testing & Bug Fixes
  SELECT * FROM (VALUES
    ('testing_month1',
     'Testing & Bug Fixes - Month 1',
     'Comprehensive testing of all APIs and UI components. Fix bugs, edge cases, error handling. Verify fairness calculations with multiple scenarios. Performance optimization.',
     15::numeric, 'medium', 'high', 'task', 'pending')
  ) t(id, title, description, estimated_hours, complexity, priority, ticket_type, status)
) tickets,
month1
WHERE month1.domain_id IS NOT NULL;

-- Insert MONTH 2-6 TICKETS: Higher Level (broader strokes)

-- MONTH 2: GitHub Integration & Onboarding (121 hours estimated)
INSERT INTO QUAD_tickets (
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, created_at
)
SELECT domain_id, title, description, estimated_hours, complexity,
       priority, ticket_type, 'pending', CURRENT_TIMESTAMP
FROM (
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core') as domain_id,
         'Month 2: GitHub OAuth Configuration' as title,
         'Register GitHub app, implement OAuth callback handler, token storage (encrypted), session creation' as description,
         8::numeric as estimated_hours, 'medium' as complexity, 'high' as priority, 'epic' as ticket_type

  UNION ALL
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
         'Month 2: GitHub Webhook Handler',
         'Implement webhook for push events, PRs, code reviews, comments. Auto-log as contributions.',
         16::numeric, 'hard', 'high', 'epic'

  UNION ALL
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
         'Month 2: Onboarding Ticket System',
         'Create onboarding workflow: skills assessment form, auto-assign role, create starter tickets for new team members',
         16::numeric, 'hard', 'high', 'epic'

  UNION ALL
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
         'Month 2: GitHub Integration Testing & SUMA TM Parallel Work',
         'Test OAuth flow end-to-end, webhook delivery, contribution logging. Parallel: SUMA smart home device discovery and control.',
         39::numeric, 'medium', 'high', 'epic'
) month2_tickets
WHERE month2_tickets.domain_id IS NOT NULL;

-- MONTH 3: Memory Management (66 hours estimated)
INSERT INTO QUAD_tickets (
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, created_at
)
SELECT domain_id, title, description, estimated_hours, complexity,
       priority, ticket_type, 'pending', CURRENT_TIMESTAMP
FROM (
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core') as domain_id,
         'Month 3: Memory Database Schema & Service' as title,
         'Design and implement user memory system: store context, track decisions, learning records. Integration with Gemini for contextual suggestions.',
         34::numeric as estimated_hours, 'hard' as complexity, 'high' as priority, 'epic' as ticket_type

  UNION ALL
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core'),
         'Month 3: Memory Timeline UI & Testing',
         'Build memory timeline component, test integration with Gemini, performance optimization',
         32::numeric, 'medium', 'high', 'epic'
) month3_tickets
WHERE month3_tickets.domain_id IS NOT NULL;

-- MONTH 4: AI Agent Auto-Fix (80 hours estimated)
INSERT INTO QUAD_tickets (
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, created_at
)
SELECT domain_id, title, description, estimated_hours, complexity,
       priority, ticket_type, 'pending', CURRENT_TIMESTAMP
FROM (
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core') as domain_id,
         'Month 4: AI Agent Framework & Auto-Fix' as title,
         'Implement agent base classes, code review agent, bug fix agent, ticket routing agent. Enable self-healing and auto-apply simple fixes.',
         80::numeric as estimated_hours, 'hard' as complexity, 'critical' as priority, 'epic' as ticket_type
) month4_tickets
WHERE month4_tickets.domain_id IS NOT NULL;

-- MONTH 5: Scale & Polish (114 hours estimated)
INSERT INTO QUAD_tickets (
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, created_at
)
SELECT domain_id, title, description, estimated_hours, complexity,
       priority, ticket_type, 'pending', CURRENT_TIMESTAMP
FROM (
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core') as domain_id,
         'Month 5: Performance, UI Polish, Multi-User Support & Analytics' as title,
         'Performance optimization, UI polish and animations, multi-user collaboration features, reporting and analytics dashboards, comprehensive documentation.',
         114::numeric as estimated_hours, 'hard' as complexity, 'high' as priority, 'epic' as ticket_type
) month5_tickets
WHERE month5_tickets.domain_id IS NOT NULL;

-- MONTH 6: Production Deployment (76 hours estimated)
INSERT INTO QUAD_tickets (
  domain_id, title, description, estimated_hours, complexity,
  priority, ticket_type, status, created_at
)
SELECT domain_id, title, description, estimated_hours, complexity,
       priority, ticket_type, 'pending', CURRENT_TIMESTAMP
FROM (
  SELECT (SELECT id FROM quad_domains WHERE name = 'QUAD Core') as domain_id,
         'Month 6: Production Deployment, Monitoring & Launch' as title,
         'Production database setup, deploy backend and frontend, monitoring and alerting, load testing, security audit, onboard team members, final polish and launch to production.',
         76::numeric as estimated_hours, 'hard' as complexity, 'critical' as priority, 'epic' as ticket_type
) month6_tickets
WHERE month6_tickets.domain_id IS NOT NULL;

-- Update Month 1 tickets with estimated_hours and complexity fields
UPDATE QUAD_tickets
SET estimated_hours = (
  CASE title
    WHEN 'Design & Document Fairness System' THEN 8
    WHEN 'Database Migrations - Fairness System Tables' THEN 12
    WHEN 'Database Migrations - GitHub Integration Tables' THEN 6
    WHEN 'Implement FairnessCalculationService' THEN 20
    WHEN 'Implement TimeTrackingService' THEN 12
    WHEN 'Implement TicketService' THEN 16
    WHEN 'Create API Endpoints - Ticket Management' THEN 12
    WHEN 'Create API Endpoints - Time Tracking' THEN 10
    WHEN 'Create API Endpoints - Fairness Calculation' THEN 8
    WHEN 'Frontend - Ticket Creation Form' THEN 12
    WHEN 'Frontend - Ticket Detail View' THEN 14
    WHEN 'Frontend - Time Logging Widget' THEN 10
    WHEN 'Frontend - Fairness Score Display Component' THEN 10
    WHEN 'Frontend - Activity Feed Component' THEN 12
    WHEN 'Testing & Bug Fixes - Month 1' THEN 15
    ELSE estimated_hours
  END
),
complexity = (
  CASE title
    WHEN 'Design & Document Fairness System' THEN 'medium'
    WHEN 'Database Migrations - Fairness System Tables' THEN 'medium'
    WHEN 'Database Migrations - GitHub Integration Tables' THEN 'easy'
    WHEN 'Implement FairnessCalculationService' THEN 'hard'
    WHEN 'Implement TimeTrackingService' THEN 'medium'
    WHEN 'Implement TicketService' THEN 'medium'
    WHEN 'Create API Endpoints - Ticket Management' THEN 'medium'
    WHEN 'Create API Endpoints - Time Tracking' THEN 'medium'
    WHEN 'Create API Endpoints - Fairness Calculation' THEN 'medium'
    WHEN 'Frontend - Ticket Creation Form' THEN 'medium'
    WHEN 'Frontend - Ticket Detail View' THEN 'medium'
    WHEN 'Frontend - Time Logging Widget' THEN 'medium'
    WHEN 'Frontend - Fairness Score Display Component' THEN 'medium'
    WHEN 'Frontend - Activity Feed Component' THEN 'medium'
    WHEN 'Testing & Bug Fixes - Month 1' THEN 'medium'
    ELSE complexity
  END
)
WHERE domain_id = (SELECT id FROM quad_domains WHERE name = 'QUAD Core');

-- Verify inserts
SELECT
  status,
  COUNT(*) as count,
  SUM(estimated_hours) as total_hours,
  AVG(estimated_hours) as avg_hours
FROM QUAD_tickets
WHERE domain_id = (SELECT id FROM quad_domains WHERE name = 'QUAD Core')
GROUP BY status
ORDER BY status;

COMMIT;

-- Summary
COMMENT ON TABLE quad_domains IS 'QUAD 6-Month Roadmap: 175h Month1 + 121h Month2 + 66h Month3 + 80h Month4 + 114h Month5 + 76h Month6 = 632 hours total';
