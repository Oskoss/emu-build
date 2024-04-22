#!/bin/bash
set -ex

echo "Today is " `date -u --date=@1404372514`

# cd ~


# git clone --depth 1 https://git.eq2emu.com/devn00b/EQ2EMu.git

# cd ~/EQ2EMu/EQ2/source/depends/recastnavigation/RecastDemo

# curl -OL https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-linux.tar.gz

# tar -xvf premake-5.0.0-beta2-linux.tar.gz

# #Fix some issue with altStackMem size
# sed -i -e 's/SIGSTKSZ/32768/g' ~/EQ2EMu/EQ2/source/depends/recastnavigation/Tests/catch.hpp

# ./premake5 gmake

# cd Build/gmake

# make

# cd ../../../..

# git clone https://github.com/fmtlib/fmt.git

# cd ~/EQ2EMu/EQ2/source/LoginServer/

# make -j$(nproc)

# cd ~/EQ2EMu/EQ2/source/WorldServer

# make -j$(nproc)

# cd ~/EQ2EMu

# mkdir Linux

# cd ~/EQ2EMu/Linux

# cp ../EQ2/source/WorldServer/eq2world ./ && cp ../EQ2/source/LoginServer/login ./

# cp -rT ../server .

# ls -ltra

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!Yay, it compiled and built!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

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

API_JSON=$(printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )
API_RESPONSE_STATUS=$(curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases -d "$API_JSON")
echo "$API_RESPONSE_STATUS"
