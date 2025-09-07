#!/usr/bin/env bash
set -euo pipefail
repo="${1:?owner/repo}"; branch="${2:-main}"
gh api -X PUT "repos/$repo/branches/$branch/protection" \
  -H "Accept: application/vnd.github+json" \
  -f required_status_checks.strict=true \
  -F required_status_checks.contexts[]="ci" \
  -F enforce_admins=true \
  -F required_pull_request_reviews.required_approving_review_count:=1 \
  -F restrictions=
echo "Protected $repo:$branch"