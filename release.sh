#!/bin/bash
set -ex

echo "Today is " `date -u --date=@1404372514`

if [[ -z "${GITHUB_ACCESS_TOKEN}" ]]; then
  echo "GITHUB_ACCESS_TOKEN not set....update and try again"
  exit 1
fi

REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)
VERSION=$(git log --pretty=format:'%H' -n 1)
MESSAGE=$(printf "Release of version %s" $VERSION)
REPO_OWNER="oskoss"
BRANCH="main"
DRAFT="false"
PRE="false"

API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "%s","name": "%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )
API_RESPONSE_STATUS=$(curl -H "Authorization: $GITHUB_ACCESS_TOKEN" --data "$API_JSON" -s -i https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases)
echo "$API_RESPONSE_STATUS"
