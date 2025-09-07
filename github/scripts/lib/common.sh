#!/usr/bin/env bash
set -euo pipefail

# Config
ORG="eoinmca"
BRANCH="main"
LABELS_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/labels.json"

# Flags
DRY="${DRY_RUN:-0}"

# Preconditions
: "${GH_TOKEN:?export GH_TOKEN=<org PAT>}"
command -v gh >/dev/null || { echo "gh not found"; exit 1; }
command -v jq >/dev/null || { echo "jq not found"; exit 1; }

log(){ printf '%s %s\n' "[$(date +%H:%M:%S)]" "$*"; }

# Iterate repos in org
list_repos(){ gh repo list "$ORG" --json name -L 200 | jq -r '.[].name'; }

# Guard: branch exists
has_branch(){ gh api "repos/$1/branches/$BRANCH" >/dev/null 2>&1; }

# gh api wrapper with dry-run
gh_json(){
  local method="$1"; shift
  if [ "$DRY" = "1" ]; then
    log "DRY gh $method $*"
  else
    gh api -X "$method" "$@"
  fi
}