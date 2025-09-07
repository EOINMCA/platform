#!/usr/bin/env bash
set -euo pipefail
: "${ORG_NAME:?ORG_NAME required}"
# Set default repo permission = none
gh api -X PATCH "orgs/$ORG_NAME" -f default_repository_permission=none >/dev/null
# Optional: default branch name for new repos
gh api -X PATCH "orgs/$ORG_NAME" -f default_repository_settings='{"default_branch":"main"}' >/dev/null || true
echo "Org settings applied."