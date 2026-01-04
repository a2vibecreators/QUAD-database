#!/bin/bash
# ==============================================================================
# QUAD Database Deploy Script
# Wrapper for sync-db.sh with common deployment options
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    echo ""
    echo -e "${CYAN}QUAD Database Deploy Script${NC}"
    echo ""
    echo "Usage: $0 <environment> <mode>"
    echo ""
    echo "Environments:"
    echo "  dev     Development database (localhost:14201)"
    echo "  qa      QA database (localhost:15201)"
    echo "  prod    Production database (Cloud SQL)"
    echo ""
    echo "Modes:"
    echo "  full    Apply full schema (128 tables) - fresh install"
    echo "  diff    Check what's missing (compare SQL vs DB)"
    echo "  apply   Apply only missing tables"
    echo "  status  Show current table count"
    echo ""
    echo "Examples:"
    echo "  $0 dev full      # Fresh install to DEV (all 128 tables)"
    echo "  $0 dev diff      # Check what's different in DEV"
    echo "  $0 qa apply      # Apply missing tables to QA"
    echo "  $0 dev status    # Show DEV table count"
    echo ""
    exit 1
}

# Parse arguments
if [[ $# -lt 2 ]]; then
    usage
fi

ENV="$1"
MODE="$2"

# Validate environment
if [[ ! "$ENV" =~ ^(dev|qa|prod)$ ]]; then
    echo -e "${RED}Error: Invalid environment '$ENV'${NC}"
    usage
fi

# Validate mode
if [[ ! "$MODE" =~ ^(full|diff|apply|status)$ ]]; then
    echo -e "${RED}Error: Invalid mode '$MODE'${NC}"
    usage
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}QUAD Database Deploy${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "Environment: ${YELLOW}$ENV${NC}"
echo -e "Mode:        ${YELLOW}$MODE${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

case $MODE in
    full)
        echo -e "${YELLOW}Applying full schema (127 tables)...${NC}"
        echo ""
        "$SCRIPT_DIR/sync-db.sh" "$ENV" --full --verbose
        ;;
    diff)
        echo -e "${YELLOW}Checking differences (SQL vs DB)...${NC}"
        echo ""
        "$SCRIPT_DIR/sync-db.sh" "$ENV"
        ;;
    apply)
        echo -e "${YELLOW}Applying missing tables...${NC}"
        echo ""
        "$SCRIPT_DIR/sync-db.sh" "$ENV" --apply
        ;;
    status)
        echo -e "${YELLOW}Checking table count...${NC}"
        echo ""
        "$SCRIPT_DIR/sync-db.sh" "$ENV" --tables-only
        ;;
esac

echo ""
echo -e "${GREEN}Done!${NC}"
