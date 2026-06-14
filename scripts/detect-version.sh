#!/usr/bin/env bash
set -euo pipefail

if command -v node >/dev/null && [ -f package.json ]; then
  UPSTREAM_VERSION="$(node -p "require('./package.json').version")"
elif command -v jq >/dev/null && [ -f package.json ]; then
  UPSTREAM_VERSION="$(jq -r .version package.json)"
else
  UPSTREAM_VERSION="$(git describe --tags --abbrev=0 upstream/master 2>/dev/null | sed 's/^v//')"
fi

if [ -z "$UPSTREAM_VERSION" ]; then
  echo "ERROR: Could not detect upstream version" >&2
  exit 1
fi

BASE_TAG="v${UPSTREAM_VERSION}"
LAST_PATCH_NUM=0
if command -v gh >/dev/null; then
  LAST_PATCH_NUM=$(gh release list --limit 200 \
    | grep -oE "${BASE_TAG}-patch\.[0-9]+" \
    | sed -E 's/.*-patch\.([0-9]+)/\1/' \
    | sort -n \
    | tail -1 || true)
fi
NEXT_PATCH_NUM=$(( ${LAST_PATCH_NUM:-0} + 1 ))
NEXT_VERSION="${BASE_TAG}-patch.${NEXT_PATCH_NUM}"

echo "UPSTREAM_VERSION=${UPSTREAM_VERSION}"
echo "BASE_TAG=${BASE_TAG}"
echo "NEXT_VERSION=${NEXT_VERSION}"

if [ "${1:-}" = "--export" ] && [ -n "${GITHUB_ENV:-}" ]; then
  echo "UPSTREAM_VERSION=${UPSTREAM_VERSION}" >> "$GITHUB_ENV"
  echo "BASE_TAG=${BASE_TAG}" >> "$GITHUB_ENV"
  echo "NEXT_VERSION=${NEXT_VERSION}" >> "$GITHUB_ENV"
fi
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "upstream_version=${UPSTREAM_VERSION}" >> "$GITHUB_OUTPUT"
  echo "base_tag=${BASE_TAG}" >> "$GITHUB_OUTPUT"
  echo "next_version=${NEXT_VERSION}" >> "$GITHUB_OUTPUT"
fi
