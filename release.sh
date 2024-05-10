#!/bin/bash
set -ex

echo "Today is " `date -u --date=@1404372514`

if [[ -z "${GITHUB_ACCESS_TOKEN}" ]]; then
  echo "GITHUB_ACCESS_TOKEN not set....update and try again"
  exit 1
fi

cd /workspace/EQ2EMu

REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)
VERSION=$(cat /workspace/cur_version)
MESSAGE=$(printf "Release of version %s" $VERSION)
REPO_OWNER="oskoss"
BRANCH="main"
DRAFT="false"
PRE="false"

RELEASE_JSON=$(printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )
RELEASE_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases -d "$RELEASE_JSON")
echo "$RELEASE_RESPONSE_STATUS"

UPLOAD_URL=$(echo "$RELEASE_RESPONSE_STATUS" | grep "upload_url")
UPLOAD_URL="${UPLOAD_URL:17:-15}"

cd /workspace/release
ls -ltra 

WORLD_UPLOAD_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/octet-stream" "$UPLOAD_URL?name=eq2world" --data-binary "@/workspace/release/eq2world")
echo "$WORLD_UPLOAD_RESPONSE_STATUS"

LOGIN_UPLOAD_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/octet-stream" "$UPLOAD_URL?name=login" --data-binary "@/workspace/release/login")
echo "$LOGIN_UPLOAD_RESPONSE_STATUS"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!            Yay, it released $VERSION               !!!"
echo "!!!    https://github.com/oskoss/emu-build/releases    !!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
