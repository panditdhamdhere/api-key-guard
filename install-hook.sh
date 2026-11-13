#!/usr/bin/env bash
# Run from the root of your git repo:  bash /path/to/install-hook.sh
set -e
HOOK_DIR="$(git rev-parse --git-path hooks)"
cp "$(dirname "$0")/pre-commit" "$HOOK_DIR/pre-commit"
chmod +x "$HOOK_DIR/pre-commit"
echo "Installed pre-commit hook in $HOOK_DIR"
