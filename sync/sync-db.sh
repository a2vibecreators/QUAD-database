#!/bin/bash
# ==============================================================================
# QUAD Database Sync Tool
# Compare database state against SQL schema files
# Compatible with bash 3.2+
# ==============================================================================

# Don't use 'set -e' - we need script to continue for --apply

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_ROOT="$(dirname "$SCRIPT_DIR")"
SQL_DIR="$DB_ROOT/sql"

DB_USER="quad_user"

# Get config for environment (bash 3.2 compatible)
get_db_config() {
    local env=$1
    case $env in
        dev)
            DB_HOST="localhost"
            DB_PORT="14201"
            DB_NAME="quad_dev_db"
            DB_PASS="quad_dev_pass"
            CONTAINER="postgres-quad-dev"
            ;;
        qa)
            DB_HOST="localhost"
            DB_PORT="15201"
            DB_NAME="quad_qa_db"
            DB_PASS="quad_qa_pass"
            CONTAINER="postgres-quad-qa"
            ;;
        prod)
            DB_HOST="cloud-sql"
            DB_PORT="5432"
            DB_NAME="quad_prod_db"
            DB_PASS="${DB_PASSWORD:-}"
            CONTAINER=""
            ;;
    esac
}

usage() {
    echo "Usage: $0 <environment> [options]"
    echo ""
    echo "Environments: dev, qa, prod"
    echo ""
    echo "Options:"
    echo "  --tables-only    Only check tables"
    echo "  --functions-only Only check functions"
    echo "  --fix            Generate fix script (don't apply)"
    echo "  --apply          Apply missing schema (creates tables)"
    echo "  --full           Apply full schema.sql (fresh install)"
    echo "  --schema-diff    Compare .tbl.sql files to database (using migra)"
    echo "  --verbose        Show detailed output"
    echo ""
    echo "Examples:"
    echo "  $0 dev                    # Check DEV database"
    echo "  $0 dev --full             # Apply full schema to DEV"
    echo "  $0 qa --tables-only       # Check QA tables only"
    echo "  $0 dev --fix              # Generate fix script for DEV"
    echo "  $0 dev --apply            # Apply missing tables to DEV"
    echo "  $0 dev --schema-diff      # Generate ALTER statements (migra)"
    exit 1
}

# Parse arguments
ENV=""
TABLES_ONLY=false
FUNCTIONS_ONLY=false
FIX_MODE=false
APPLY_MODE=false
FULL_MODE=false
SCHEMA_DIFF=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        dev|qa|prod)
            ENV="$1"
            ;;
        --tables-only)
            TABLES_ONLY=true
            ;;
        --functions-only)
            FUNCTIONS_ONLY=true
            ;;
        --fix)
            FIX_MODE=true
            ;;
        --apply)
            APPLY_MODE=true
            ;;
        --full)
            FULL_MODE=true
            ;;
        --schema-diff)
            SCHEMA_DIFF=true
            ;;
        --verbose)
            VERBOSE=true
            ;;
        *)
            usage
            ;;
    esac
    shift
done

if [[ -z "$ENV" ]]; then
    usage
fi

get_db_config "$ENV"

echo "=========================================="
echo "QUAD Database Sync Tool"
echo "=========================================="
echo "Environment: $ENV"
echo "Database:    $DB_NAME @ $DB_HOST:$DB_PORT"
echo "SQL Source:  $SQL_DIR"
echo "=========================================="
echo ""

# Function to run psql
run_psql() {
    if [[ -n "$CONTAINER" ]]; then
        docker exec "$CONTAINER" psql -U $DB_USER -d $DB_NAME -t -A -c "$1" 2>/dev/null
    else
        PGPASSWORD="$DB_PASS" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -A -c "$1" 2>/dev/null
    fi
}

run_psql_file() {
    if [[ -n "$CONTAINER" ]]; then
        docker exec -i "$CONTAINER" psql -U $DB_USER -d $DB_NAME < "$1" 2>&1
    else
        PGPASSWORD="$DB_PASS" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME < "$1" 2>&1
    fi
}

# Schema diff mode - compare .tbl.sql files to database using migra
if [[ "$SCHEMA_DIFF" == true ]]; then
    echo "========================================"
    echo "QUAD Database Schema Diff (using migra)"
    echo "========================================"

    # Check if migra is installed
    if ! command -v migra &> /dev/null; then
        echo -e "${RED}ERROR: migra is not installed${NC}"
        echo ""
        echo "Install migra:"
        echo "  brew install pipx"
        echo "  pipx install 'migra[pg]'"
        echo "  pipx inject migra setuptools"
        echo ""
        exit 1
    fi

    # Step 1: Create temp database
    TEMP_DB="${DB_NAME}_temp_$(date +%s)"
    echo "[1/6] Creating temporary database: $TEMP_DB"
    run_psql "CREATE DATABASE $TEMP_DB;" > /dev/null

    # Step 2: Load all .tbl.sql files into temp database
    echo "[2/6] Loading .tbl.sql files into temporary database..."
    for tbl_file in $(find "$SQL_DIR" -name "*.tbl.sql" | sort); do
        if [[ "$VERBOSE" == true ]]; then
            echo "  Loading: $(basename $tbl_file)"
        fi
        if [[ -n "$CONTAINER" ]]; then
            docker exec -i "$CONTAINER" psql -U $DB_USER -d $TEMP_DB < "$tbl_file" 2>&1 | grep -v "already exists" > /dev/null || true
        else
            PGPASSWORD="$DB_PASS" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $TEMP_DB -f "$tbl_file" 2>&1 | grep -v "already exists" > /dev/null || true
        fi
    done

    # Step 3: Run migra to compare schemas
    echo "[3/6] Running migra schema comparison..."
    ACTUAL_URL="postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
    TEMP_URL="postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${TEMP_DB}"

    ALTER_SQL=$(migra --unsafe "$ACTUAL_URL" "$TEMP_URL" 2>&1)

    if [[ -z "$ALTER_SQL" ]] || [[ "$ALTER_SQL" == *"Identical"* ]]; then
        echo -e "${GREEN}✓ No schema differences detected${NC}"
        echo "[4/6] Cleaning up temporary database..."
        run_psql "DROP DATABASE $TEMP_DB;" > /dev/null
        exit 0
    fi

    # Step 4: Show differences
    echo "[4/6] Schema differences detected:"
    echo "────────────────────────────────────────"
    echo "$ALTER_SQL"
    echo "────────────────────────────────────────"
    echo ""

    # Step 5: Prompt for metadata
    echo "[5/6] Migration metadata:"
    read -p "  Jira ticket (e.g., QUAD-123): " JIRA_TICKET
    read -p "  Release version (e.g., v1.2.0): " RELEASE_VERSION
    read -p "  Description: " DESCRIPTION

    # Step 6: Create migration file
    echo "[6/6] Creating migration file..."

    # Get next version number
    MIGRATIONS_DIR="$DB_ROOT/migrations"
    if [[ ! -d "$MIGRATIONS_DIR" ]]; then
        mkdir -p "$MIGRATIONS_DIR"
        NEXT_VERSION=1
    else
        LAST_VERSION=$(ls "$MIGRATIONS_DIR" 2>/dev/null | grep -E "^V[0-9]+" | sed 's/V\([0-9]*\)__.*/\1/' | sort -n | tail -1)
        if [[ -z "$LAST_VERSION" ]]; then
            NEXT_VERSION=1
        else
            NEXT_VERSION=$((LAST_VERSION + 1))
        fi
    fi

    # Generate filename
    DESCRIPTION_KEBAB=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    MIGRATION_FILE="$MIGRATIONS_DIR/V${NEXT_VERSION}__${JIRA_TICKET}_${DESCRIPTION_KEBAB}.sql"

    # Write migration file with metadata header
    cat > "$MIGRATION_FILE" << EOF
-- ============================================================
-- QUAD Platform Schema Migration
-- ============================================================
-- Migration Version: $NEXT_VERSION
-- Jira Ticket: https://jira.company.com/browse/${JIRA_TICKET}
-- Release: $RELEASE_VERSION
-- Author: $(whoami)
-- Generated Date: $(date +"%Y-%m-%d %H:%M:%S")
-- Generated by: sync-db.sh (migra)
-- Source: quad-database/sql/**/*.tbl.sql
-- ============================================================

-- Description: $DESCRIPTION

$ALTER_SQL

-- ============================================================
-- Rollback Instructions:
-- Review the ALTER statements above and manually reverse them
-- Example:
--   ALTER TABLE ... ADD COLUMN ... → ALTER TABLE ... DROP COLUMN ...
--   ALTER TABLE ... ALTER COLUMN ... → ALTER TABLE ... ALTER COLUMN ... (reverse)
-- ============================================================
EOF

    echo -e "${GREEN}✓ Created: $MIGRATION_FILE${NC}"
    echo ""

    # Cleanup temp database
    run_psql "DROP DATABASE $TEMP_DB;" > /dev/null

    # Prompt to apply
    read -p "Apply migration now? [y/N] " CONFIRM
    if [[ "$CONFIRM" == "y" ]] || [[ "$CONFIRM" == "Y" ]]; then
        echo "Applying migration..."
        run_psql_file "$MIGRATION_FILE"

        echo -e "${GREEN}✓ Migration applied successfully${NC}"
        echo ""
        echo "Migration history tracked in Git:"
        echo "  git add migrations/V${NEXT_VERSION}__${JIRA_TICKET}_${DESCRIPTION_KEBAB}.sql sql/**/*.tbl.sql"
        echo "  git commit -m '${JIRA_TICKET}: $DESCRIPTION'"
    else
        echo -e "${YELLOW}Migration file created but not applied${NC}"
        echo "To apply later: ./sync-db.sh $ENV --apply-migration V${NEXT_VERSION}"
    fi

    exit 0
fi

# Full schema mode - apply all 127 tables in dependency order
if [[ "$FULL_MODE" == true ]]; then
    echo -e "${YELLOW}Applying full schema (127 tables in dependency order)...${NC}"
    echo ""

    # Apply tables in correct dependency order (matching schema.sql)
    # This order ensures foreign key references are satisfied

    apply_table_file() {
        local FILE="$1"
        local DIR=$(dirname "$FILE" | xargs basename)
        if [[ -f "$FILE" ]]; then
            echo -n "  $DIR/$(basename $FILE)... "
            OUTPUT=$(run_psql_file "$FILE" 2>&1)
            if echo "$OUTPUT" | grep -qi "already exists"; then
                echo -e "${YELLOW}exists${NC}"
            elif echo "$OUTPUT" | grep -qi "error"; then
                echo -e "${RED}ERROR${NC}"
                if [[ "$VERBOSE" == true ]]; then
                    echo "    $OUTPUT" | head -3
                fi
            else
                echo -e "${GREEN}OK${NC}"
            fi
        fi
    }

    # ============================================================================
    # CORE TABLES (Organizations, Users, Roles) - 13 tables
    # ============================================================================
    echo -e "${YELLOW}[1/16] Core Tables...${NC}"
    apply_table_file "$SQL_DIR/core/QUAD_org_tiers.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_organizations.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_org_settings.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_org_setup_status.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_sso_configs.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_users.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_user_sessions.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_email_verification_codes.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_roles.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_core_roles.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_org_members.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_org_invitations.tbl.sql"
    apply_table_file "$SQL_DIR/core/QUAD_config_settings.tbl.sql"

    # ============================================================================
    # DOMAINS & PROJECTS - 10 tables
    # ============================================================================
    echo -e "${YELLOW}[2/16] Domain Tables...${NC}"
    apply_table_file "$SQL_DIR/domains/QUAD_domains.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_domain_members.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_domain_resources.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_domain_operations.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_resource_attributes.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_resource_attribute_requirements.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_requirements.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_milestones.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_adoption_matrix.tbl.sql"
    apply_table_file "$SQL_DIR/domains/QUAD_workload_metrics.tbl.sql"

    # ============================================================================
    # CIRCLES & TICKETS - 8 tables
    # ============================================================================
    echo -e "${YELLOW}[3/16] Ticket Tables...${NC}"
    apply_table_file "$SQL_DIR/tickets/QUAD_circles.tbl.sql"
    apply_table_file "$SQL_DIR/tickets/QUAD_circle_members.tbl.sql"
    apply_table_file "$SQL_DIR/tickets/QUAD_cycles.tbl.sql"
    apply_table_file "$SQL_DIR/tickets/QUAD_tickets.tbl.sql"
    apply_table_file "$SQL_DIR/tickets/QUAD_ticket_comments.tbl.sql"
    apply_table_file "$SQL_DIR/tickets/QUAD_ticket_time_logs.tbl.sql"
    apply_table_file "$SQL_DIR/tickets/QUAD_ticket_skills.tbl.sql"
    apply_table_file "$SQL_DIR/tickets/QUAD_assignment_scores.tbl.sql"

    # ============================================================================
    # GIT & PULL REQUESTS - 6 tables
    # ============================================================================
    echo -e "${YELLOW}[4/16] Git Tables...${NC}"
    apply_table_file "$SQL_DIR/git/QUAD_git_integrations.tbl.sql"
    apply_table_file "$SQL_DIR/git/QUAD_git_repositories.tbl.sql"
    apply_table_file "$SQL_DIR/git/QUAD_pull_requests.tbl.sql"
    apply_table_file "$SQL_DIR/git/QUAD_pr_reviewers.tbl.sql"
    apply_table_file "$SQL_DIR/git/QUAD_pr_approvals.tbl.sql"
    apply_table_file "$SQL_DIR/git/QUAD_git_operations.tbl.sql"

    # ============================================================================
    # MEETINGS & CALENDAR - 4 tables
    # ============================================================================
    echo -e "${YELLOW}[5/16] Meeting Tables...${NC}"
    apply_table_file "$SQL_DIR/meetings/QUAD_meeting_integrations.tbl.sql"
    apply_table_file "$SQL_DIR/meetings/QUAD_meetings.tbl.sql"
    apply_table_file "$SQL_DIR/meetings/QUAD_meeting_action_items.tbl.sql"
    apply_table_file "$SQL_DIR/meetings/QUAD_meeting_follow_ups.tbl.sql"

    # ============================================================================
    # QUAD MEMORY SYSTEM - 8 tables
    # ============================================================================
    echo -e "${YELLOW}[6/16] Memory Tables...${NC}"
    apply_table_file "$SQL_DIR/memory/QUAD_memory_documents.tbl.sql"
    apply_table_file "$SQL_DIR/memory/QUAD_memory_chunks.tbl.sql"
    apply_table_file "$SQL_DIR/memory/QUAD_memory_keywords.tbl.sql"
    apply_table_file "$SQL_DIR/memory/QUAD_memory_templates.tbl.sql"
    apply_table_file "$SQL_DIR/memory/QUAD_context_sessions.tbl.sql"
    apply_table_file "$SQL_DIR/memory/QUAD_context_requests.tbl.sql"
    apply_table_file "$SQL_DIR/memory/QUAD_context_rules.tbl.sql"
    apply_table_file "$SQL_DIR/memory/QUAD_memory_update_queue.tbl.sql"

    # ============================================================================
    # AI & PROVIDERS - 16 tables
    # ============================================================================
    echo -e "${YELLOW}[7/16] AI Tables...${NC}"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_provider_config.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_configs.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_operations.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_contexts.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_context_relationships.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_code_reviews.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_conversations.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_messages.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_user_memories.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_activity_routing.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_analysis_cache.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_credit_balances.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_ai_credit_transactions.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_platform_credit_pool.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_platform_pool_transactions.tbl.sql"
    apply_table_file "$SQL_DIR/ai/QUAD_rag_indexes.tbl.sql"

    # ============================================================================
    # INFRASTRUCTURE - 9 tables
    # ============================================================================
    echo -e "${YELLOW}[8/16] Infrastructure Tables...${NC}"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_infrastructure_config.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_sandbox_instances.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_sandbox_usage.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_ticket_sandbox_groups.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_codebase_files.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_codebase_indexes.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_code_cache.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_cache_usage.tbl.sql"
    apply_table_file "$SQL_DIR/infrastructure/QUAD_indexing_usage.tbl.sql"

    # ============================================================================
    # SKILLS & ASSIGNMENTS - 3 tables
    # ============================================================================
    echo -e "${YELLOW}[9/16] Skills Tables...${NC}"
    apply_table_file "$SQL_DIR/skills/QUAD_skills.tbl.sql"
    apply_table_file "$SQL_DIR/skills/QUAD_user_skills.tbl.sql"
    apply_table_file "$SQL_DIR/skills/QUAD_skill_feedback.tbl.sql"

    # ============================================================================
    # FLOWS & DEPLOYMENTS - 9 tables
    # ============================================================================
    echo -e "${YELLOW}[10/16] Flow Tables...${NC}"
    apply_table_file "$SQL_DIR/flows/QUAD_flows.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_flow_stage_history.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_flow_branches.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_environments.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_deployment_recipes.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_deployments.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_release_notes.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_release_contributors.tbl.sql"
    apply_table_file "$SQL_DIR/flows/QUAD_rollback_operations.tbl.sql"

    # ============================================================================
    # PORTAL & ACCESS - 2 tables
    # ============================================================================
    echo -e "${YELLOW}[11/16] Portal Tables...${NC}"
    apply_table_file "$SQL_DIR/portal/QUAD_portal_access.tbl.sql"
    apply_table_file "$SQL_DIR/portal/QUAD_portal_audit_log.tbl.sql"

    # ============================================================================
    # OTHER TABLES - 16 tables
    # ============================================================================
    echo -e "${YELLOW}[12/16] Other Tables...${NC}"
    apply_table_file "$SQL_DIR/other/QUAD_notifications.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_notification_preferences.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_user_role_allocations.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_approvals.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_file_imports.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_work_sessions.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_user_activity_summaries.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_database_connections.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_database_operations.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_database_approvals.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_anonymization_rules.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_verification_requests.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_validated_credentials.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_integration_health_checks.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_api_access_config.tbl.sql"
    apply_table_file "$SQL_DIR/other/QUAD_api_request_logs.tbl.sql"

    # ============================================================================
    # ANALYTICS & METRICS - 9 tables
    # ============================================================================
    echo -e "${YELLOW}[13/16] Analytics Tables...${NC}"
    apply_table_file "$SQL_DIR/analytics/QUAD_cycle_risk_predictions.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_story_point_suggestions.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_technical_debt_scores.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_dora_metrics.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_ranking_configs.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_user_rankings.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_kudos.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_cost_estimates.tbl.sql"
    apply_table_file "$SQL_DIR/analytics/QUAD_risk_factors.tbl.sql"

    # ============================================================================
    # SECURITY - 4 tables
    # ============================================================================
    echo -e "${YELLOW}[14/16] Security Tables...${NC}"
    apply_table_file "$SQL_DIR/security/QUAD_secret_scans.tbl.sql"
    apply_table_file "$SQL_DIR/security/QUAD_secret_rotations.tbl.sql"
    apply_table_file "$SQL_DIR/security/QUAD_incident_runbooks.tbl.sql"
    apply_table_file "$SQL_DIR/security/QUAD_runbook_executions.tbl.sql"

    # ============================================================================
    # ONBOARDING & SETUP - 8 tables
    # ============================================================================
    echo -e "${YELLOW}[15/16] Onboarding Tables...${NC}"
    apply_table_file "$SQL_DIR/onboarding/QUAD_resource_setup_templates.tbl.sql"
    apply_table_file "$SQL_DIR/onboarding/QUAD_user_resource_setups.tbl.sql"
    apply_table_file "$SQL_DIR/onboarding/QUAD_setup_bundles.tbl.sql"
    apply_table_file "$SQL_DIR/onboarding/QUAD_user_setup_journeys.tbl.sql"
    apply_table_file "$SQL_DIR/onboarding/QUAD_developer_onboarding_templates.tbl.sql"
    apply_table_file "$SQL_DIR/onboarding/QUAD_developer_onboarding_progress.tbl.sql"
    apply_table_file "$SQL_DIR/onboarding/QUAD_training_content.tbl.sql"
    apply_table_file "$SQL_DIR/onboarding/QUAD_training_completions.tbl.sql"

    # ============================================================================
    # SLACK INTEGRATION - 2 tables
    # ============================================================================
    echo -e "${YELLOW}[16/16] Slack Tables...${NC}"
    apply_table_file "$SQL_DIR/slack/QUAD_slack_bot_commands.tbl.sql"
    apply_table_file "$SQL_DIR/slack/QUAD_slack_messages.tbl.sql"

    echo ""
    echo -e "${GREEN}✅ Full schema applied! (127 tables in 16 categories)${NC}"
    echo ""
fi

# Get tables from database (case-insensitive - PostgreSQL stores as lowercase)
get_db_tables() {
    run_psql "SELECT UPPER(tablename) FROM pg_tables WHERE schemaname = 'public' AND (tablename LIKE 'quad_%' OR tablename LIKE 'QUAD_%') ORDER BY tablename;"
}

# Get tables from SQL files (migrations + sql folder)
get_sql_tables() {
    MIGRATIONS_DIR="$DB_ROOT/migrations"

    # Search in migrations folder and sql folder
    {
        find "$MIGRATIONS_DIR" -name "*.sql" 2>/dev/null
        find "$SQL_DIR" -name "*.sql" 2>/dev/null
    } | while read f; do
        # Extract all CREATE TABLE statements from each file
        grep -iE 'CREATE TABLE' "$f" 2>/dev/null | grep -oiE 'QUAD_[a-zA-Z0-9_]+' | head -20
    done | sort -u | grep -v '^$'
}

# Get functions from database
get_db_functions() {
    run_psql "SELECT proname FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid WHERE n.nspname = 'public' AND (proname LIKE '%quad%' OR proname LIKE '%QUAD%') ORDER BY proname;"
}

# Get functions from SQL files
get_sql_functions() {
    find "$SQL_DIR" -name "*.fnc.sql" 2>/dev/null | while read f; do
        grep -oE 'CREATE (OR REPLACE )?FUNCTION [^(]+' "$f" 2>/dev/null | sed 's/CREATE \(OR REPLACE \)\?FUNCTION //g' | tr -d ' '
    done | sort -u
}

# Compare tables
echo -e "${YELLOW}Checking Tables...${NC}"
echo "-------------------------------------------"

DB_TABLES=$(get_db_tables)
SQL_TABLES=$(get_sql_tables)

if [[ "$VERBOSE" == true ]]; then
    echo "DB Tables:"
    echo "$DB_TABLES" | head -20
    echo ""
    echo "SQL Tables:"
    echo "$SQL_TABLES" | head -20
    echo ""
fi

MISSING_IN_DB=""
EXTRA_IN_DB=""
MISSING_COUNT=0
EXTRA_COUNT=0

# Find tables in SQL but not in DB (case-insensitive comparison)
while IFS= read -r table; do
    if [[ -n "$table" ]]; then
        # Convert both to uppercase for comparison
        TABLE_UPPER=$(echo "$table" | tr '[:lower:]' '[:upper:]')
        if ! echo "$DB_TABLES" | tr '[:lower:]' '[:upper:]' | grep -q "^$TABLE_UPPER$"; then
            MISSING_IN_DB="$MISSING_IN_DB$table"$'\n'
            MISSING_COUNT=$((MISSING_COUNT + 1))
        fi
    fi
done <<< "$SQL_TABLES"

# Find tables in DB but not in SQL (case-insensitive comparison)
while IFS= read -r table; do
    if [[ -n "$table" ]]; then
        # Convert both to uppercase for comparison
        TABLE_UPPER=$(echo "$table" | tr '[:lower:]' '[:upper:]')
        if ! echo "$SQL_TABLES" | tr '[:lower:]' '[:upper:]' | grep -q "^$TABLE_UPPER$"; then
            EXTRA_IN_DB="$EXTRA_IN_DB$table"$'\n'
            EXTRA_COUNT=$((EXTRA_COUNT + 1))
        fi
    fi
done <<< "$DB_TABLES"

DB_TABLE_COUNT=$(echo "$DB_TABLES" | grep -c . 2>/dev/null || echo 0)
SQL_TABLE_COUNT=$(echo "$SQL_TABLES" | grep -c . 2>/dev/null || echo 0)

if [[ $MISSING_COUNT -eq 0 ]]; then
    echo -e "${GREEN}[OK] All SQL tables exist in database${NC}"
else
    echo -e "${RED}[MISSING] $MISSING_COUNT tables in SQL but not in DB:${NC}"
    echo "$MISSING_IN_DB" | while read t; do
        [[ -n "$t" ]] && echo "  - $t"
    done
fi

if [[ $EXTRA_COUNT -gt 0 ]]; then
    echo -e "${YELLOW}[EXTRA] $EXTRA_COUNT tables in DB but not in SQL:${NC}"
    echo "$EXTRA_IN_DB" | while read t; do
        [[ -n "$t" ]] && echo "  - $t"
    done
fi

echo ""

# Compare functions (if not tables-only)
if [[ "$TABLES_ONLY" == false ]]; then
    echo -e "${YELLOW}Checking Functions...${NC}"
    echo "-------------------------------------------"

    DB_FUNCS=$(get_db_functions)
    SQL_FUNCS=$(get_sql_functions)

    MISSING_FUNC_COUNT=0

    while IFS= read -r func; do
        if [[ -n "$func" ]] && ! echo "$DB_FUNCS" | grep -qi "^$func$"; then
            [[ $MISSING_FUNC_COUNT -eq 0 ]] && echo -e "${RED}[MISSING] Functions in SQL but not in DB:${NC}"
            echo "  - $func"
            MISSING_FUNC_COUNT=$((MISSING_FUNC_COUNT + 1))
        fi
    done <<< "$SQL_FUNCS"

    if [[ $MISSING_FUNC_COUNT -eq 0 ]]; then
        echo -e "${GREEN}[OK] All SQL functions exist in database${NC}"
    fi
fi

echo ""

# Summary
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo "Tables:    $DB_TABLE_COUNT in DB, $SQL_TABLE_COUNT in SQL"
echo "Missing:   $MISSING_COUNT tables"
echo "Extra:     $EXTRA_COUNT tables"
echo "=========================================="

# Generate fix script if requested
if [[ "$FIX_MODE" == true && $MISSING_COUNT -gt 0 ]]; then
    FIX_FILE="$DB_ROOT/sync/fix-$ENV-$(date +%Y%m%d-%H%M%S).sql"
    echo ""
    echo -e "${YELLOW}Generating fix script: $FIX_FILE${NC}"

    echo "-- QUAD Database Fix Script" > "$FIX_FILE"
    echo "-- Generated: $(date)" >> "$FIX_FILE"
    echo "-- Environment: $ENV" >> "$FIX_FILE"
    echo "" >> "$FIX_FILE"

    echo "$MISSING_IN_DB" | while read table; do
        if [[ -n "$table" ]]; then
            SQL_FILE=$(find "$SQL_DIR" -iname "*${table}*.sql" 2>/dev/null | head -1)
            if [[ -n "$SQL_FILE" ]]; then
                echo "-- From: $SQL_FILE" >> "$FIX_FILE"
                cat "$SQL_FILE" >> "$FIX_FILE"
                echo "" >> "$FIX_FILE"
            fi
        fi
    done

    echo -e "${GREEN}Fix script generated: $FIX_FILE${NC}"
fi

# Apply missing tables if requested
if [[ "$APPLY_MODE" == true && $MISSING_COUNT -gt 0 ]]; then
    echo ""
    echo -e "${YELLOW}Applying missing tables...${NC}"

    echo "$MISSING_IN_DB" | while read table; do
        if [[ -n "$table" ]]; then
            SQL_FILE=$(find "$SQL_DIR" -iname "*${table}*.sql" 2>/dev/null | head -1)
            if [[ -n "$SQL_FILE" ]]; then
                echo "  Applying: $SQL_FILE"
                run_psql_file "$SQL_FILE" > /dev/null 2>&1 || echo "    Warning: Some errors (table may have deps)"
            fi
        fi
    done

    echo -e "${GREEN}Done applying missing tables${NC}"
fi

exit 0
