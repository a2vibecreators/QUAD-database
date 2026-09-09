-- Migration V4: Create Hook System Tables for QUAD Platform
-- Date: January 15, 2026
-- Purpose: Create tables for intelligent conversation memory, context tracking, and pattern learning
--
-- Patent Pending: Token optimization through hierarchical memory and adaptive importance scoring
--
-- Run this AFTER V3__create_multi_tenant_domain_sso.sql

-- ============================================================================
-- TABLE 1: quad_hook_memories
-- ============================================================================
-- Purpose: Store conversation memories with importance scoring and shelf life

CREATE TABLE IF NOT EXISTS quad_hook_memories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
  project_name VARCHAR(255) NOT NULL,
  context_type VARCHAR(50) NOT NULL CHECK (context_type IN ('ticket', 'project', 'user', 'global')),
  context_id VARCHAR(255),  -- ticket_id, project_id, etc.

  -- Memory content
  user_input TEXT NOT NULL,
  topic_detected VARCHAR(255),
  importance_score INTEGER NOT NULL CHECK (importance_score BETWEEN 1 AND 10),
  importance_suggested INTEGER,  -- Gemini's original suggestion
  importance_manual_override BOOLEAN DEFAULT FALSE,

  -- Shelf life
  shelf_life_category VARCHAR(20) NOT NULL CHECK (shelf_life_category IN ('high', 'medium', 'low')),
  expires_at TIMESTAMP NOT NULL,
  is_expired BOOLEAN DEFAULT FALSE,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  last_accessed_at TIMESTAMP DEFAULT NOW(),
  access_count INTEGER DEFAULT 0
);

-- Indexes
CREATE INDEX idx_memories_user ON quad_hook_memories(user_id);
CREATE INDEX idx_memories_project ON quad_hook_memories(project_name);
CREATE INDEX idx_memories_context ON quad_hook_memories(context_type, context_id);
CREATE INDEX idx_memories_importance ON quad_hook_memories(importance_score);
CREATE INDEX idx_memories_expires_at ON quad_hook_memories(expires_at);
CREATE INDEX idx_memories_is_expired ON quad_hook_memories(is_expired);
CREATE INDEX idx_memories_topic ON quad_hook_memories(topic_detected);

-- Trigger
CREATE TRIGGER trg_memories_updated_at
  BEFORE UPDATE ON quad_hook_memories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE quad_hook_memories IS 'Conversation memories with importance scoring and expiration (Patent Pending: Token optimization)';

-- ============================================================================
-- TABLE 2: quad_hook_user_patterns
-- ============================================================================
-- Purpose: Learn user typing patterns for adaptive pause detection

CREATE TABLE IF NOT EXISTS quad_hook_user_patterns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

  -- Typing behavior
  avg_typing_speed_wpm DECIMAL(5,2) DEFAULT 40.0,
  avg_message_length INTEGER DEFAULT 100,
  avg_pause_between_messages_ms INTEGER DEFAULT 3000,

  -- Burst patterns
  detects_short_bursts BOOLEAN DEFAULT FALSE,
  short_burst_avg_messages INTEGER DEFAULT 2,
  short_burst_timeout_ms INTEGER DEFAULT 1500,

  -- Long thought patterns
  detects_long_thoughts BOOLEAN DEFAULT FALSE,
  long_thought_avg_length INTEGER DEFAULT 200,
  long_thought_timeout_ms INTEGER DEFAULT 5000,

  -- Learning stats
  total_messages_analyzed INTEGER DEFAULT 0,
  last_pattern_update TIMESTAMP DEFAULT NOW(),
  confidence_score DECIMAL(3,2) DEFAULT 0.0,  -- 0.0 to 1.0

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(user_id)
);

CREATE INDEX idx_user_patterns_user ON quad_hook_user_patterns(user_id);

CREATE TRIGGER trg_user_patterns_updated_at
  BEFORE UPDATE ON quad_hook_user_patterns
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE quad_hook_user_patterns IS 'User typing behavior patterns for adaptive pause detection (Patent Pending)';

-- ============================================================================
-- TABLE 3: quad_hook_importance_patterns
-- ============================================================================
-- Purpose: Learn patterns from user manual importance adjustments

CREATE TABLE IF NOT EXISTS quad_hook_importance_patterns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

  -- Pattern data
  topic VARCHAR(255) NOT NULL,
  context_keywords TEXT[],  -- Array of keywords
  avg_gemini_score DECIMAL(4,2),
  avg_user_adjusted_score DECIMAL(4,2),
  adjustment_difference DECIMAL(4,2),  -- Positive = user scores higher, Negative = user scores lower

  -- Learning stats
  sample_count INTEGER DEFAULT 1,
  confidence_score DECIMAL(3,2) DEFAULT 0.0,
  last_adjustment TIMESTAMP DEFAULT NOW(),

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(user_id, topic)
);

CREATE INDEX idx_importance_patterns_user ON quad_hook_importance_patterns(user_id);
CREATE INDEX idx_importance_patterns_topic ON quad_hook_importance_patterns(topic);
CREATE INDEX idx_importance_patterns_confidence ON quad_hook_importance_patterns(confidence_score);

CREATE TRIGGER trg_importance_patterns_updated_at
  BEFORE UPDATE ON quad_hook_importance_patterns
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE quad_hook_importance_patterns IS 'Pattern learning from user importance adjustments (Patent Pending: Adaptive AI scoring)';

-- ============================================================================
-- TABLE 4: quad_hook_context_history
-- ============================================================================
-- Purpose: Track context switches (project -> ticket -> project)

CREATE TABLE IF NOT EXISTS quad_hook_context_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,

  -- Context data
  context_type VARCHAR(50) NOT NULL CHECK (context_type IN ('ticket', 'project', 'user', 'global')),
  context_id VARCHAR(255),
  context_name VARCHAR(255) NOT NULL,
  project_name VARCHAR(255),

  -- Timing
  started_at TIMESTAMP NOT NULL DEFAULT NOW(),
  paused_at TIMESTAMP,
  resumed_at TIMESTAMP,
  ended_at TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE,

  -- Stats
  total_messages INTEGER DEFAULT 0,
  total_memories_created INTEGER DEFAULT 0,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_context_history_user ON quad_hook_context_history(user_id);
CREATE INDEX idx_context_history_context ON quad_hook_context_history(context_type, context_id);
CREATE INDEX idx_context_history_is_active ON quad_hook_context_history(is_active);
CREATE INDEX idx_context_history_project ON quad_hook_context_history(project_name);

CREATE TRIGGER trg_context_history_updated_at
  BEFORE UPDATE ON quad_hook_context_history
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE quad_hook_context_history IS 'Context switch tracking (ticket/project/user) with hierarchical priority (Patent Pending)';

-- ============================================================================
-- TABLE 5: quad_tickets
-- ============================================================================
-- Purpose: Store tickets for context tracking

CREATE TABLE IF NOT EXISTS quad_tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id VARCHAR(100) NOT NULL UNIQUE,  -- e.g., SQUAD-123
  user_id UUID NOT NULL REFERENCES QUAD_users(id) ON DELETE CASCADE,
  project_name VARCHAR(255) NOT NULL,

  -- Ticket data
  title VARCHAR(500) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'paused', 'completed', 'cancelled')),
  priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),

  -- File tracking
  related_files TEXT[],  -- Array of file paths

  -- Timing
  started_at TIMESTAMP,
  paused_at TIMESTAMP,
  resumed_at TIMESTAMP,
  completed_at TIMESTAMP,
  last_active_at TIMESTAMP DEFAULT NOW(),

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_tickets_ticket_id ON quad_tickets(ticket_id);
CREATE INDEX idx_tickets_user ON quad_tickets(user_id);
CREATE INDEX idx_tickets_project ON quad_tickets(project_name);
CREATE INDEX idx_tickets_status ON quad_tickets(status);
CREATE INDEX idx_tickets_last_active ON quad_tickets(last_active_at);

CREATE TRIGGER trg_tickets_updated_at
  BEFORE UPDATE ON quad_tickets
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE quad_tickets IS 'Tickets for context tracking and switching';

-- ============================================================================
-- FUNCTION: get_active_context
-- ============================================================================
-- Purpose: Get user's current active context (ticket > project > user)

CREATE OR REPLACE FUNCTION get_active_context(p_user_id UUID)
RETURNS TABLE(
  context_type VARCHAR(50),
  context_id VARCHAR(255),
  context_name VARCHAR(255),
  weight DECIMAL(3,1)
) AS $$
BEGIN
  -- Check for active ticket (weight 2.0)
  RETURN QUERY
  SELECT
    'ticket'::VARCHAR(50),
    t.ticket_id::VARCHAR(255),
    t.title::VARCHAR(255),
    2.0::DECIMAL(3,1)
  FROM quad_tickets t
  WHERE t.user_id = p_user_id
    AND t.status = 'in_progress'
    AND t.last_active_at > NOW() - INTERVAL '30 minutes'
  LIMIT 1;

  -- If no active ticket, return active project context (weight 1.0)
  IF NOT FOUND THEN
    RETURN QUERY
    SELECT
      'project'::VARCHAR(50),
      ch.context_id::VARCHAR(255),
      ch.context_name::VARCHAR(255),
      1.0::DECIMAL(3,1)
    FROM quad_hook_context_history ch
    WHERE ch.user_id = p_user_id
      AND ch.context_type = 'project'
      AND ch.is_active = TRUE
    ORDER BY ch.started_at DESC
    LIMIT 1;
  END IF;

  -- If no project context, return user context (weight 0.5)
  IF NOT FOUND THEN
    RETURN QUERY
    SELECT
      'user'::VARCHAR(50),
      p_user_id::VARCHAR(255),
      'User Context'::VARCHAR(255),
      0.5::DECIMAL(3,1);
  END IF;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_active_context IS 'Get user active context with hierarchical priority (ticket > project > user)';

-- ============================================================================
-- FUNCTION: mark_expired_memories
-- ============================================================================
-- Purpose: Mark memories as expired (called by cleanup job)

CREATE OR REPLACE FUNCTION mark_expired_memories()
RETURNS INTEGER AS $$
DECLARE
  updated_count INTEGER;
BEGIN
  UPDATE quad_hook_memories
  SET is_expired = TRUE
  WHERE expires_at <= NOW()
    AND is_expired = FALSE;

  GET DIAGNOSTICS updated_count = ROW_COUNT;
  RETURN updated_count;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION mark_expired_memories IS 'Mark expired memories (hard expiration strategy)';

-- ============================================================================
-- FUNCTION: delete_expired_memories
-- ============================================================================
-- Purpose: Delete expired memories (called by cleanup job)

CREATE OR REPLACE FUNCTION delete_expired_memories()
RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM quad_hook_memories
  WHERE is_expired = TRUE
    AND expires_at < NOW() - INTERVAL '7 days';  -- Keep expired for 7 days before deletion

  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION delete_expired_memories IS 'Delete expired memories after grace period';

-- ============================================================================
-- End of Migration V4
-- ============================================================================
