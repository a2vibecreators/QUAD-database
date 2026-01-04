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
    echo "  --verbose        Show detailed output"
    echo ""
    echo "Examples:"
    echo "  $0 dev                    # Check DEV database"
    echo "  $0 dev --full             # Apply full schema to DEV"
    echo "  $0 qa --tables-only       # Check QA tables only"
    echo "  $0 dev --fix              # Generate fix script for DEV"
    echo "  $0 dev --apply            # Apply missing tables to DEV"
    exit 1
}

# Parse arguments
ENV=""
TABLES_ONLY=false
FUNCTIONS_ONLY=false
FIX_MODE=false
APPLY_MODE=false
FULL_MODE=false
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

# Full schema mode - apply migration files in order
if [[ "$FULL_MODE" == true ]]; then
    echo -e "${YELLOW}Applying full schema (migration files)...${NC}"
    echo ""

    MIGRATIONS_DIR="$DB_ROOT/migrations"
    FEATURES_FILE="$SQL_DIR/003_quad_features.sql"

    # Define migration files in order
    MIGRATION_FILES=(
        "$MIGRATIONS_DIR/000_create_core_tables.sql"
        "$MIGRATIONS_DIR/001_create_resource_attribute_model.sql"
        "$MIGRATIONS_DIR/002_create_multi_tenant_domain_sso.sql"
        "$FEATURES_FILE"
    )

    for FILE in "${MIGRATION_FILES[@]}"; do
        if [[ -f "$FILE" ]]; then
            echo "  Applying: $(basename $FILE)"
            OUTPUT=$(run_psql_file "$FILE" 2>&1)

            # Check for errors (ignore "already exists" messages)
            if echo "$OUTPUT" | grep -qi "error" | grep -v "already exists"; then
                echo -e "${RED}    Warning: Some errors occurred${NC}"
                if [[ "$VERBOSE" == true ]]; then
                    echo "$OUTPUT" | head -20
                fi
            else
                echo -e "${GREEN}    OK${NC}"
            fi
        else
            echo -e "${RED}  Missing: $(basename $FILE)${NC}"
        fi
    done

    echo ""

    # Also apply individual .tbl.sql files from sql subdirectories
    echo -e "${YELLOW}Applying individual table files...${NC}"

    # Functions first (needed by tables)
    for FILE in "$SQL_DIR"/functions/*.fnc.sql; do
        if [[ -f "$FILE" ]]; then
            echo "  Applying: $(basename $FILE)"
            run_psql_file "$FILE" > /dev/null 2>&1 || echo -e "${YELLOW}    (already exists or skipped)${NC}"
        fi
    done

    # Then individual table files (in dependency order)
    TBL_DIRS=("core" "domains" "infrastructure" "memory")
    for DIR in "${TBL_DIRS[@]}"; do
        if [[ -d "$SQL_DIR/$DIR" ]]; then
            for FILE in "$SQL_DIR/$DIR"/*.tbl.sql; do
                if [[ -f "$FILE" ]]; then
                    echo "  Applying: $DIR/$(basename $FILE)"
                    OUTPUT=$(run_psql_file "$FILE" 2>&1)
                    if echo "$OUTPUT" | grep -qi "already exists"; then
                        echo -e "${YELLOW}    (already exists)${NC}"
                    elif echo "$OUTPUT" | grep -qi "error"; then
                        echo -e "${RED}    Warning: $OUTPUT${NC}" | head -1
                    else
                        echo -e "${GREEN}    OK${NC}"
                    fi
                fi
            done
        fi
    done

    echo ""
    echo -e "${GREEN}Full schema applied!${NC}"
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
