#!/bin/bash

set -eu

git config user.name s2mr
git config user.email s2mr@users.noreply.github.com
TARGET_BRANCH=$(echo "$COMMENT_BODY" | sed -e 's/\/ota --with \(.*\).*/\1/g')

git pull
git remote -v
git branch -a

if [ "$TARGET_BRANCH" != "" ]
then
    git fetch "$TARGET_BRANCH"
    git checkout origin "$TARGET_BRANCH"
fi

git commit --allow-empty -m "[ota]${COMMENT_BODY##/ota}"
git push
