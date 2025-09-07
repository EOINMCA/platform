#!/usr/bin/env bash
set -euo pipefail
# Requires: lib/common.sh sourced

apply_rule_protect_main(){
  local repo="$1"
  has_branch "$repo" || { log "! skip $repo: no $BRANCH"; return 0; }

  if [ "$DRY" = "1" ]; then
    log "DRY protect $repo:$BRANCH"
    return 0
  fi

  gh api -X PUT "repos/$repo/branches/$BRANCH/protection" \
    -H "Accept: application/vnd.github+json" \
    --input - <<'EOF' >/dev/null
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": null,
  "restrictions": null
}
EOF
  log "✓ protected $repo:$BRANCH"
}