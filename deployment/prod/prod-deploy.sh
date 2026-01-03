#!/bin/bash
# Deploy database schema to PROD environment
# REQUIRES APPROVAL - Will prompt for confirmation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/../scripts/deploy.sh" prod "$@"
