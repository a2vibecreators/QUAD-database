#!/bin/bash
# SUMA AI - Master Deployment Script
# Deploys all QUAD_suma_* tables and seed data to DEV database
#
# Author: Gopi Addanke
# Date: January 10, 2026

set -e  # Exit on error

DB_CONTAINER="postgres-quad-dev"
DB_USER="quad_user"
DB_NAME="quad_dev_db"

echo "==================================================================="
echo "SUMA AI - Database Deployment to DEV"
echo "==================================================================="
echo ""

# Check if container is running
if ! docker ps | grep -q $DB_CONTAINER; then
    echo "❌ Error: $DB_CONTAINER is not running"
    echo "Start it with: docker start $DB_CONTAINER"
    exit 1
fi

echo "✅ Database container is running"
echo ""

# 1. Deploy Tables
echo "📦 Deploying tables..."
echo "-------------------------------------------------------------------"

TABLES=(
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_api_keys.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_credits.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_usage.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_templates.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_apps.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_chats.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_user_context.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/tables/quad_platform/QUAD_suma_activity_types.sql"
)

for table_file in "${TABLES[@]}"; do
    table_name=$(basename "$table_file" .sql)
    echo "  → $table_name"
    docker cp "$table_file" $DB_CONTAINER:/tmp/
    docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -f /tmp/$(basename "$table_file") > /dev/null 2>&1 || echo "    (already exists)"
done

echo ""
echo "✅ Tables deployed"
echo ""

# 2. Deploy Seed Data
echo "🌱 Deploying seed data..."
echo "-------------------------------------------------------------------"

SEEDS=(
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/seeds/suma_starter_templates.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/seeds/suma_activity_types.sql"
    "/Users/semostudio/git/a2vibes/QUAD/quad-database/sql/seeds/suma_api_test_companies.sql"
)

for seed_file in "${SEEDS[@]}"; do
    seed_name=$(basename "$seed_file" .sql)
    echo "  → $seed_name"
    docker cp "$seed_file" $DB_CONTAINER:/tmp/
    docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -f /tmp/$(basename "$seed_file") > /dev/null 2>&1
done

echo ""
echo "✅ Seed data deployed"
echo ""

# 3. Verify Deployment
echo "🔍 Verifying deployment..."
echo "-------------------------------------------------------------------"

# Count templates
TEMPLATE_COUNT=$(docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM QUAD_suma_templates WHERE is_starter = true;" | tr -d ' ')
echo "  → Starter templates: $TEMPLATE_COUNT/8"

# Count activities
ACTIVITY_COUNT=$(docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM QUAD_suma_activity_types WHERE is_active = true;" | tr -d ' ')
echo "  → Activity types: $ACTIVITY_COUNT/8"

# Count test companies
COMPANY_COUNT=$(docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM QUAD_organizations WHERE name IN ('NutriNine Health', 'A2Vibe Creators', 'TestCorp Ltd');" | tr -d ' ')
echo "  → Test organizations: $COMPANY_COUNT/3"

echo ""

if [ "$TEMPLATE_COUNT" -eq "8" ] && [ "$ACTIVITY_COUNT" -eq "8" ] && [ "$COMPANY_COUNT" -eq "3" ]; then
    echo "==================================================================="
    echo "✅ SUMA AI DATABASE DEPLOYMENT SUCCESSFUL!"
    echo "==================================================================="
    echo ""
    echo "Summary:"
    echo "  • 8 tables deployed (api_keys, credits, usage, templates, apps, chats, user_context, activity_types)"
    echo "  • 8 FREE starter templates seeded"
    echo "  • 8 activity types with pre/post hooks seeded"
    echo "  • 3 test organizations seeded"
    echo ""
    echo "Next steps:"
    echo "  1. Test API: curl http://localhost:3100/v1/chat -H 'X-API-Key: sk_test_...'"
    echo "  2. Test Web: http://localhost:3200"
    echo "  3. View templates: http://localhost:3200/templates"
    echo ""
else
    echo "⚠️  Warning: Some seed data may be incomplete"
    echo "  Expected: 8 templates, 8 activities, 3 companies"
    echo "  Got: $TEMPLATE_COUNT templates, $ACTIVITY_COUNT activities, $COMPANY_COUNT companies"
fi
