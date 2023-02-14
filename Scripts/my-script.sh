#!/bin/bash

git config user.name s2mr
git config user.email s2mr@users.noreply.github.com
BODY="${github.event.comment.body}"
TARGET_BRANCH="$(sed -e 's/\/ota --with \(.*\) .*/\1/g')"

if [ "$TARGET_BRANCH" = "" ]
then
    git checkout "$TARGET_BRANCH"
fi

git commit --allow-empty -m "[ota]${BODY##/ota}"
git push
