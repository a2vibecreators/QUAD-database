#!/bin/bash
# Deploy database schema to QA environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/../scripts/deploy.sh" qa "$@"
