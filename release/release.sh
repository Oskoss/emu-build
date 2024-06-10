#!/bin/bash
set -euxo pipefail

echo "Today is " `date -u --date=@1404372514`

if [[ -z "${GITHUB_ACCESS_TOKEN}" ]]; then
  echo "GITHUB_ACCESS_TOKEN not set....update and try again"
  exit 1
fi

cd /workspace/EQ2EMu
COMMIT_MSG=$(git log -1 --oneline | awk '{printf "%s\\\\\\n", $0}')

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

curl -vLO https://www.zeklabs.com/dl/eq2emudb.rar
curl -vLO https://www.zeklabs.com/dl/eq2emulssql.rar

WORLD_UPLOAD_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/octet-stream" "$UPLOAD_URL?name=eq2world" --data-binary "@/workspace/release/eq2world")
echo "$WORLD_UPLOAD_RESPONSE_STATUS"

LOGIN_UPLOAD_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/octet-stream" "$UPLOAD_URL?name=login" --data-binary "@/workspace/release/login")
echo "$LOGIN_UPLOAD_RESPONSE_STATUS"

SERVER_UPLOAD_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/octet-stream" "$UPLOAD_URL?name=server.tar.gz" --data-binary "@/workspace/release/server.tar.gz")
echo "$SERVER_UPLOAD_RESPONSE_STATUS"

WORLD_DB_UPLOAD_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/octet-stream" "$UPLOAD_URL?name=eq2emuworldsql.rar" --data-binary "@/workspace/release/eq2emudb.rar")
echo "$WORLD_DB_UPLOAD_RESPONSE_STATUS"

LOGIN_DB_UPLOAD_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" -H "Content-Type: application/octet-stream" "$UPLOAD_URL?name=eq2emuloginsql.rar" --data-binary "@/workspace/release/eq2emulssql.rar")
echo "$LOGIN_DB_UPLOAD_RESPONSE_STATUS"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!            Yay, it released $VERSION               !!!"
echo "!!!    https://github.com/oskoss/emu-build/releases    !!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
