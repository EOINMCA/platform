#!/usr/bin/env bash
set -euo pipefail
repo="${1:?owner/repo required}"
existing=$(gh api "repos/$repo/labels" --paginate --jq '.[].name')
jq -c '.[]' github/labels.json | while read -r lbl; do
  name=$(jq -r .name <<<"$lbl"); color=$(jq -r .color <<<"$lbl")
  if grep -qx "$name" <<<"$existing"; then
    gh api --method PATCH "repos/$repo/labels/$name" -f color="$color" >/dev/null
  else
    gh api --method POST "repos/$repo/labels" -f name="$name" -f color="$color" >/dev/null
  fi
done
echo "Labels synced for $repo."