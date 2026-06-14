#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODE="${1:-fast}"
UPSTREAM_REMOTE="${UPSTREAM_REMOTE:-upstream}"
UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-master}"
UPSTREAM_REF="$UPSTREAM_REMOTE/$UPSTREAM_BRANCH"

echo "==== Fetching upstream ===="
git fetch "$UPSTREAM_REMOTE" "$UPSTREAM_BRANCH" --tags --prune

echo "==== Creating clean worktree ===="
WORKTREE="/tmp/telegram-tt-patch-check-$$"
git worktree add "$WORKTREE" "$UPSTREAM_REF" --detach
trap 'git worktree remove --force "$WORKTREE" 2>/dev/null || true' EXIT

cd "$WORKTREE"

echo "==== Applying patches ===="
PATCH_DIR="$SCRIPT_DIR/../patches/cur" "$SCRIPT_DIR/apply-patches.sh"

echo "==== Running sanitizer ===="
cd "$SCRIPT_DIR/.."
"$SCRIPT_DIR/check-no-upstream-refs.sh"

if [ "$MODE" = "full" ]; then
  echo "==== Full checks are intentionally delegated to GitHub Actions ===="
else
  echo "==== Fast mode: patch application and sanitizer only ===="
fi

echo ""
echo "All patch checks passed (mode: $MODE)."
