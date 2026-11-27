#!/usr/bin/env bash
# Protects the default branch of a repository in the InvestLab organization.
#
# Usage: scripts/apply-rulesets.sh <repo> [<required check>...]
# Example: scripts/apply-rulesets.sh investlab-market-data "commitlint / commitlint" build
#
# The ruleset requires a pull request, linear history and the given status
# checks (reported by GitHub Actions), and blocks force pushes and deletion.
# Nobody can bypass it, organization owners included. The script also limits
# the repository to squash merges, with the pull request title as the commit
# message, so history on main is one Conventional Commit per pull request.
#
# Running it again updates the existing ruleset instead of adding a new one.
# Requires the GitHub CLI, signed in as an organization owner.

set -euo pipefail

ORG="${ORG:-InvestLab}"
RULESET_NAME="protect-main"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <repo> [<required check>...]" >&2
  exit 2
fi

repo="$1"
shift

# Each required check must come from the GitHub Actions app, so another app
# cannot satisfy it by reporting a status with the same name.
# Check names go into JSON as plain strings, so quotes and backslashes are refused.
checks_json=""
if [[ $# -gt 0 ]]; then
  actions_app_id=$(gh api apps/github-actions --jq .id)
  for check in "$@"; do
    if [[ "$check" == *'"'* || "$check" == *'\'* ]]; then
      echo "error: check name must not contain quotes or backslashes: $check" >&2
      exit 2
    fi
    checks_json+="${checks_json:+,}{\"context\": \"$check\", \"integration_id\": $actions_app_id}"
  done
fi

status_checks_rule=""
if [[ -n "$checks_json" ]]; then
  status_checks_rule=",
    {
      \"type\": \"required_status_checks\",
      \"parameters\": {
        \"strict_required_status_checks_policy\": true,
        \"required_status_checks\": [$checks_json]
      }
    }"
fi

ruleset=$(cat <<EOF
{
  "name": "$RULESET_NAME",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [],
  "conditions": {
    "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] }
  },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    { "type": "required_linear_history" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true,
        "allowed_merge_methods": ["squash"]
      }
    }$status_checks_rule
  ]
}
EOF
)

echo "Setting squash-only merges on $ORG/$repo"
gh api --method PATCH "repos/$ORG/$repo" --silent \
  -F allow_squash_merge=true \
  -F allow_merge_commit=false \
  -F allow_rebase_merge=false \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY \
  -F delete_branch_on_merge=true

existing_id=$(gh api "repos/$ORG/$repo/rulesets?includes_parents=false" \
  --jq ".[] | select(.name == \"$RULESET_NAME\" and .source_type == \"Repository\") | .id")

if [[ -n "$existing_id" ]]; then
  echo "Updating ruleset $RULESET_NAME (id $existing_id) on $ORG/$repo"
  printf '%s' "$ruleset" | gh api --method PUT "repos/$ORG/$repo/rulesets/$existing_id" --input - --silent
else
  echo "Creating ruleset $RULESET_NAME on $ORG/$repo"
  printf '%s' "$ruleset" | gh api --method POST "repos/$ORG/$repo/rulesets" --input - --silent
fi

echo "Done. Rulesets on $ORG/$repo:"
gh api "repos/$ORG/$repo/rulesets?includes_parents=false" --jq '.[] | "  \(.id)  \(.name)  \(.enforcement)"'
