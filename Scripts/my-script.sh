#!/bin/bash

set -eu

git config user.name s2mr
git config user.email s2mr@users.noreply.github.com
TARGET_BRANCH=$(echo "$COMMENT_BODY" | sed -e 's/\/ota --with \(.*\).*/\1/g')

echo "$TARGET_BRANCH"
git status
git branch

if [ "$TARGET_BRANCH" != "" ]
then
    git checkout "$TARGET_BRANCH"
fi

git commit --allow-empty -m "[ota]${COMMENT_BODY##/ota}"
git push
