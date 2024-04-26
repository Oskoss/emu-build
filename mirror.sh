#!/bin/bash
set -eux

whoami
echo "Today is " `date -u --date=@1404372514`

mkdir -p ~/.ssh 

chmod 0700 ~/.ssh 

echo "${GITHUB_SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa  

chmod 600 ~/.ssh/id_rsa

cat ~/.ssh/id_rsa

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_rsa

export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o
StrictHostKeyChecking=no"

git clone --progress https://git.eq2emu.com/devn00b/EQ2EMu.git

cd EQ2EMu

git remote add origin git@github.com:User/UserRepo.git

step_commits=$(git log --oneline --reverse refs/heads/master | awk 'NR % 100 == 0')

echo "$step_commits" | while read commit message; do git push github  $commit:refs/heads/master; done

git push github  --mirror
