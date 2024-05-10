#!/bin/bash
set -eux

echo "Today is " `date -u --date=@1404372514`

pwd
ls -ltra
whoami

cd /workspace

git clone --depth 1 https://git.eq2emu.com/devn00b/EQ2EMu.git

cd /workspace/EQ2EMu

echo $(git rev-parse --short HEAD) > /workspace/cur_version

cd /workspace

curl -OL https://storage.googleapis.com/eq2emu-devn00b-hash/version

PREV_GIT_HASH=$(cat /workspace/version)
CUR_GIT_HASH=$(cat  /workspace/cur_version)

if [[ $PREV_GIT_HASH == $CUR_GIT_HASH ]]; then
    echo "No new commits found. See you soon!"
    exit 1
else
    echo "New commits found. Running compile, build, release!"
    exit 0
fi
