#!/bin/bash
# Deploy database schema to DEV environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/../scripts/deploy.sh" dev "$@"
