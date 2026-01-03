#!/bin/bash
# ==============================================================================
# QUAD Database Sync Tool
# Compare database state against SQL schema files
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_ROOT="$(dirname "$SCRIPT_DIR")"
SQL_DIR="$DB_ROOT/sql"

# Environment configs
declare -A DB_HOSTS=(
    ["dev"]="localhost"
    ["qa"]="localhost"
    ["prod"]="cloud-sql"
)

declare -A DB_PORTS=(
    ["dev"]="14201"
    ["qa"]="15201"
    ["prod"]="5432"
)

declare -A DB_NAMES=(
    ["dev"]="quad_dev_db"
    ["qa"]="quad_qa_db"
    ["prod"]="quad_prod_db"
)

DB_USER="quad_user"

usage() {
    echo "Usage: $0 <environment> [options]"
    echo ""
    echo "Environments: dev, qa, prod"
    echo ""
    echo "Options:"
    echo "  --tables-only    Only check tables"
    echo "  --functions-only Only check functions"
    echo "  --fix            Generate fix script (don't apply)"
    echo "  --apply          Apply missing schema (DANGEROUS)"
    echo "  --verbose        Show detailed output"
    echo ""
    echo "Examples:"
    echo "  $0 dev                    # Check DEV database"
    echo "  $0 qa --tables-only       # Check QA tables only"
    echo "  $0 dev --fix              # Generate fix script for DEV"
    exit 1
}

# Parse arguments
ENV=""
TABLES_ONLY=false
FUNCTIONS_ONLY=false
FIX_MODE=false
APPLY_MODE=false
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

DB_HOST="${DB_HOSTS[$ENV]}"
DB_PORT="${DB_PORTS[$ENV]}"
DB_NAME="${DB_NAMES[$ENV]}"

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
    if [[ "$ENV" == "dev" || "$ENV" == "qa" ]]; then
        docker exec postgres-quad-$ENV psql -U $DB_USER -d $DB_NAME -t -A -c "$1" 2>/dev/null
    else
        PGPASSWORD="$DB_PASSWORD" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -A -c "$1" 2>/dev/null
    fi
}

# Get tables from database
get_db_tables() {
    run_psql "SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename LIKE 'QUAD_%' ORDER BY tablename;"
}

# Get tables from SQL files
get_sql_tables() {
    find "$SQL_DIR" -name "*.tbl.sql" -o -name "*.sql" | while read f; do
        grep -oE 'CREATE TABLE[^(]+' "$f" 2>/dev/null | sed 's/CREATE TABLE \(IF NOT EXISTS \)\?//g' | tr -d ' "'
    done | sort -u
}

# Get functions from database
get_db_functions() {
    run_psql "SELECT proname FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid WHERE n.nspname = 'public' AND proname LIKE '%quad%' OR proname LIKE '%QUAD%' ORDER BY proname;"
}

# Get functions from SQL files
get_sql_functions() {
    find "$SQL_DIR" -name "*.fnc.sql" | while read f; do
        grep -oE 'CREATE (OR REPLACE )?FUNCTION [^(]+' "$f" 2>/dev/null | sed 's/CREATE \(OR REPLACE \)\?FUNCTION //g' | tr -d ' '
    done | sort -u
}

# Compare tables
echo -e "${YELLOW}Checking Tables...${NC}"
echo "-------------------------------------------"

DB_TABLES=$(get_db_tables)
SQL_TABLES=$(get_sql_tables)

MISSING_IN_DB=()
EXTRA_IN_DB=()

while IFS= read -r table; do
    if [[ -n "$table" ]] && ! echo "$DB_TABLES" | grep -q "^$table$"; then
        MISSING_IN_DB+=("$table")
    fi
done <<< "$SQL_TABLES"

while IFS= read -r table; do
    if [[ -n "$table" ]] && ! echo "$SQL_TABLES" | grep -q "^$table$"; then
        EXTRA_IN_DB+=("$table")
    fi
done <<< "$DB_TABLES"

if [[ ${#MISSING_IN_DB[@]} -eq 0 ]]; then
    echo -e "${GREEN}[OK] All SQL tables exist in database${NC}"
else
    echo -e "${RED}[MISSING] Tables in SQL but not in DB:${NC}"
    for t in "${MISSING_IN_DB[@]}"; do
        echo "  - $t"
    done
fi

if [[ ${#EXTRA_IN_DB[@]} -gt 0 ]]; then
    echo -e "${YELLOW}[EXTRA] Tables in DB but not in SQL:${NC}"
    for t in "${EXTRA_IN_DB[@]}"; do
        echo "  - $t"
    done
fi

echo ""

# Compare functions (if not tables-only)
if [[ "$TABLES_ONLY" == false ]]; then
    echo -e "${YELLOW}Checking Functions...${NC}"
    echo "-------------------------------------------"

    DB_FUNCS=$(get_db_functions)
    SQL_FUNCS=$(get_sql_functions)

    MISSING_FUNCS=()

    while IFS= read -r func; do
        if [[ -n "$func" ]] && ! echo "$DB_FUNCS" | grep -qi "^$func$"; then
            MISSING_FUNCS+=("$func")
        fi
    done <<< "$SQL_FUNCS"

    if [[ ${#MISSING_FUNCS[@]} -eq 0 ]]; then
        echo -e "${GREEN}[OK] All SQL functions exist in database${NC}"
    else
        echo -e "${RED}[MISSING] Functions in SQL but not in DB:${NC}"
        for f in "${MISSING_FUNCS[@]}"; do
            echo "  - $f"
        done
    fi
fi

echo ""

# Summary
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo "Tables:    $(echo "$DB_TABLES" | wc -l | tr -d ' ') in DB, $(echo "$SQL_TABLES" | wc -l | tr -d ' ') in SQL"
echo "Missing:   ${#MISSING_IN_DB[@]} tables"
echo "Extra:     ${#EXTRA_IN_DB[@]} tables"
echo "=========================================="

# Generate fix script if requested
if [[ "$FIX_MODE" == true && ${#MISSING_IN_DB[@]} -gt 0 ]]; then
    FIX_FILE="$DB_ROOT/sync/fix-$ENV-$(date +%Y%m%d-%H%M%S).sql"
    echo ""
    echo -e "${YELLOW}Generating fix script: $FIX_FILE${NC}"

    echo "-- QUAD Database Fix Script" > "$FIX_FILE"
    echo "-- Generated: $(date)" >> "$FIX_FILE"
    echo "-- Environment: $ENV" >> "$FIX_FILE"
    echo "" >> "$FIX_FILE"

    for table in "${MISSING_IN_DB[@]}"; do
        SQL_FILE=$(find "$SQL_DIR" -name "*${table}*.sql" | head -1)
        if [[ -n "$SQL_FILE" ]]; then
            echo "-- From: $SQL_FILE" >> "$FIX_FILE"
            cat "$SQL_FILE" >> "$FIX_FILE"
            echo "" >> "$FIX_FILE"
        fi
    done

    echo -e "${GREEN}Fix script generated: $FIX_FILE${NC}"
fi

exit 0
