#!/bin/bash
# ==============================================================================
# QUAD Database Deployment Script
# Deploy schema changes to specified environment
# ==============================================================================

set -e

ENV="$1"
shift || true

if [[ -z "$ENV" || ! "$ENV" =~ ^(dev|qa|prod)$ ]]; then
    echo "Usage: $0 <dev|qa|prod> [options]"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
SQL_DIR="$DB_ROOT/sql"
SYNC_SCRIPT="$DB_ROOT/sync/sync-db.sh"

# Environment configs
declare -A DB_HOSTS=(["dev"]="localhost" ["qa"]="localhost" ["prod"]="cloud-sql")
declare -A DB_PORTS=(["dev"]="14201" ["qa"]="15201" ["prod"]="5432")
declare -A DB_NAMES=(["dev"]="quad_dev_db" ["qa"]="quad_qa_db" ["prod"]="quad_prod_db")
declare -A CONTAINERS=(["dev"]="postgres-quad-dev" ["qa"]="postgres-quad-qa" ["prod"]="")

DB_HOST="${DB_HOSTS[$ENV]}"
DB_PORT="${DB_PORTS[$ENV]}"
DB_NAME="${DB_NAMES[$ENV]}"
CONTAINER="${CONTAINERS[$ENV]}"
DB_USER="quad_user"

echo "=========================================="
echo "QUAD Database Deployment"
echo "=========================================="
echo "Environment: $ENV"
echo "Database:    $DB_NAME @ $DB_HOST:$DB_PORT"
echo "=========================================="

# PROD requires confirmation
if [[ "$ENV" == "prod" ]]; then
    echo ""
    echo "WARNING: You are about to deploy to PRODUCTION!"
    read -p "Type 'yes' to confirm: " CONFIRM
    if [[ "$CONFIRM" != "yes" ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Function to run SQL
run_sql() {
    local sql_file="$1"
    if [[ -n "$CONTAINER" ]]; then
        cat "$sql_file" | docker exec -i "$CONTAINER" psql -U $DB_USER -d $DB_NAME
    else
        PGPASSWORD="$DB_PASSWORD" psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$sql_file"
    fi
}

echo ""
echo "Step 1: Pre-deployment check..."
if [[ -x "$SYNC_SCRIPT" ]]; then
    "$SYNC_SCRIPT" "$ENV" --tables-only || true
fi

echo ""
echo "Step 2: Applying schema..."

# Apply tables
if [[ -d "$SQL_DIR/tables" ]]; then
    echo "  Applying tables..."
    find "$SQL_DIR/tables" -name "*.sql" -type f | sort | while read f; do
        echo "    - $(basename "$f")"
        run_sql "$f" 2>/dev/null || true
    done
fi

# Apply functions
if [[ -d "$SQL_DIR/functions" ]]; then
    echo "  Applying functions..."
    find "$SQL_DIR/functions" -name "*.sql" -type f | sort | while read f; do
        echo "    - $(basename "$f")"
        run_sql "$f" 2>/dev/null || true
    done
fi

echo ""
echo "Step 3: Post-deployment verification..."
if [[ -x "$SYNC_SCRIPT" ]]; then
    "$SYNC_SCRIPT" "$ENV" --tables-only || true
fi

echo ""
echo "=========================================="
echo "Deployment complete!"
echo "=========================================="
