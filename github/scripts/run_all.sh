#!/usr/bin/env bash
set -euo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
. "$BASE/lib/common.sh"

log "Actor: $(gh api user --jq .login)"
log "Org  : $(gh api orgs/$ORG --jq .login)"
[ "$DRY" = "1" ] && log "DRY_RUN=1 (no changes will be made)"

# Load rule files
for f in "$BASE"/rules/*.sh; do . "$f"; done

# Run rules on each repo
REPOS="$(list_repos)"
for name in $REPOS; do
  repo="$ORG/$name"
  log ">> $repo"
  apply_rule_protect_main "$repo"
  apply_rule_sync_labels "$repo"
done

log "Done."