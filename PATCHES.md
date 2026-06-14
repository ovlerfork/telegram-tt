# Telegram TT patchset

This repository is maintained as a patch-based fork of Telegram Web A.

Upstream is treated as read-only. Local changes are stored as replayable patch files in `patches/cur` and applied with `git am --3way`.

## Branches

| Branch | Purpose | Writer |
| --- | --- | --- |
| `patchset` | Patch files, scripts, workflows, and docs. This is the default branch. | Humans |
| `master` | Tracks upstream `master`. | CI / maintainers |
| `patched` | Generated branch: upstream plus patches applied. | CI only |

## Current patches

- `0001-feat-load-all-pending-join-request-and-ban-all-delet.patch` — load all pending join requests, ban deleted accounts, and accept users with GIC.

## Apply locally

```bash
git fetch upstream master
git worktree add /tmp/telegram-tt-source upstream/master --detach
cd /tmp/telegram-tt-source
PATCH_DIR=/path/to/telegram-tt/patches/cur /path/to/telegram-tt/scripts/apply-patches.sh
```

## Refresh patches

From a branch containing upstream plus local patch commits:

```bash
UPSTREAM_REF=upstream/master scripts/refresh-patches.sh
```

## Verify patch mechanics

```bash
scripts/check-patches.sh fast
```

Full dependency installation, lint, typecheck, tests, packaging, and release are delegated to GitHub Actions.
