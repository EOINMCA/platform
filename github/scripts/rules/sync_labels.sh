#!/usr/bin/env bash
set -euo pipefail
# Requires: lib/common.sh sourced

apply_rule_sync_labels(){
  local repo="$1"
  [ -f "$LABELS_FILE" ] || { log "! missing $LABELS_FILE"; return 1; }

  local existing
  existing="$(gh api "repos/$repo/labels" --paginate --jq '.[].name' 2>/dev/null || true)"

  jq -c '.[]' "$LABELS_FILE" | while read -r lbl; do
    local name color
    name="$(jq -r .name <<<"$lbl")"
    color="$(jq -r .color <<<"$lbl")"

    if grep -qx "$name" <<<"$existing"; then
      gh_json PATCH "repos/$repo/labels/$name" -f color="$color" >/dev/null || true
    else
      gh_json POST  "repos/$repo/labels"       -f name="$name" -f color="$color" >/dev/null || true
    fi
  done

  log "✓ labels $repo"
}