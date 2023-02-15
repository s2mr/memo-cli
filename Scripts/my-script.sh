#!/bin/bash -x

set -eu

git config user.name s2mr
git config user.email s2mr@users.noreply.github.com

TARGET_BRANCH=$(echo "$COMMENT_BODY" | sed -e 's/\/ota --with \(.*\).*/\1/g')

if [ "$TARGET_BRANCH" != "" ]
then
    git pull
    git checkout "$TARGET_BRANCH"
    git pull origin "$PR_BRANCH" # -m "[ota] Merge branch '$PR_BRANCH' into $TARGET_BRANCH"
else
    git commit --allow-empty -m "[ota]${COMMENT_BODY##/ota}"
fi

git push