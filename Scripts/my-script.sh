#!/bin/bash

set -eu

git config user.name s2mr
git config user.email s2mr@users.noreply.github.com
PR_BRANCH=$GITHUB_HEAD_REF

echo "~~~"
echo "$GITHUB_HEAD_REF"
echo "$GITHUB_BASE_REF"
echo "$GITHUB_SHA"
echo "~~~"

TARGET_BRANCH=$(echo "$COMMENT_BODY" | sed -e 's/\/ota --with \(.*\).*/\1/g')

if [ "$TARGET_BRANCH" != "" ]
then
    git pull
    git checkout "$TARGET_BRANCH"
    git merge -m "[ota] Merge branch '$PR_BRANCH' into $TARGET_BRANCH" "$PR_BRANCH"
else
    git commit --allow-empty -m "[ota]${COMMENT_BODY##/ota}"
fi

git push