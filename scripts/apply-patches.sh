#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PATCH_DIR="${PATCH_DIR:-${SCRIPT_DIR}/../patches/cur}"

if [ ! -d "$PATCH_DIR" ]; then
  echo "ERROR: Patch directory not found: $PATCH_DIR" >&2
  exit 1
fi

shopt -s nullglob
PATCHES=("$PATCH_DIR"/*.patch)
if [ ${#PATCHES[@]} -eq 0 ]; then
  echo "No patches found in $PATCH_DIR"
  exit 0
fi

git config rerere.enabled true

APPLIED=0
for patch in "${PATCHES[@]}"; do
  NAME="$(basename "$patch")"
  echo "==== Applying: $NAME ===="
  if ! git am --3way "$patch"; then
    echo ""
    echo "FAILED: $NAME"
    echo ""
    echo "Conflict files:"
    git diff --name-only --diff-filter=U
    echo ""
    echo "To resolve:"
    echo "  1. Fix conflicts in the listed files"
    echo "  2. git add <resolved-files>"
    echo "  3. git am --continue"
    echo "  4. Then run scripts/refresh-patches.sh to update the patchset"
    exit 1
  fi
  APPLIED=$((APPLIED + 1))
done

echo ""
echo "All $APPLIED patches applied successfully."
