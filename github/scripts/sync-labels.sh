#!/usr/bin/env bash
set -euo pipefail
repo="${1:?owner/repo}"
existing=$(gh api "repos/$repo/labels" --paginate --jq '.[].name')
jq -c '.[]' github/labels.json | while read -r lbl; do
  n=$(jq -r .name <<<"$lbl"); c=$(jq -r .color <<<"$lbl")
  if grep -qx "$n" <<<"$existing"; then
    gh api --method PATCH "repos/$repo/labels/$n" -f color="$c" >/dev/null
  else
    gh api --method POST "repos/$repo/labels" -f name="$n" -f color="$c" >/dev/null
  fi
done
echo "Labels synced for $repo"