#!/bin/bash
set -euxo pipefail

echo "Today is " `date -u --date=@1404372514`

if [[ -z "${GITHUB_ACCESS_TOKEN}" ]]; then
  echo "GITHUB_ACCESS_TOKEN not set....update and try again"
  exit 1
fi

cd /workspace/EQ2EMu
COMMIT_MSG=$(git rev-list --format=%s%b --max-count=1 HEAD | awk '{printf "%s\\\\\\\\n", $0}')

echo $COMMIT_MSG

REPO_OWNER="oskoss"
REPO_NAME="emu-build"
VERSION=$(cat /workspace/cur_version)

MESSAGE=$(printf "Release of EQ2EMu https://www.eq2emu.com\\\\n%s" "$COMMIT_MSG")
BRANCH="main"
DRAFT="false"
PRE="false"
echo $MESSAGE

printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" > release.json
cat release.json

RELEASE_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases -d "@release.json")
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
