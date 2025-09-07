#!/usr/bin/env bash
set -euo pipefail
ORG_NAME="${ORG_NAME:?ORG_NAME required}"
NAME="protect-default-branch"

# delete existing with same name if present
EXIST_ID=$(gh api "orgs/$ORG_NAME/rulesets" --jq ".[] | select(.name==\"$NAME\") | .id" || true)
[ -n "${EXIST_ID:-}" ] && gh api -X DELETE "orgs/$ORG_NAME/rulesets/$EXIST_ID" >/dev/null || true

gh api -X POST "orgs/$ORG_NAME/rulesets" \
  -H "Accept: application/vnd.github+json" \
  -f name="$NAME" \
  -F target='branch' \
  -F enforcement='active' \
  -F conditions='{"ref_name":{"include":["~DEFAULT_BRANCH"],"exclude":[]}}' \
  -F rules='[
    {"type":"deletion"},
    {"type":"non_fast_forward"},
    {"type":"pull_request","parameters":{"required_approving_review_count":1,"dismiss_stale_reviews_on_push":true,"require_code_owner_review":false}},
    {"type":"required_status_checks","parameters":{"strict_required_status_checks":true,"required_status_checks":["ci"]}}
  ]' >/dev/null

echo "Org ruleset applied for $ORG_NAME."