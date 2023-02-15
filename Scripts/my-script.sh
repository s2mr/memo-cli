#!/bin/bash -x

set -u

git config user.name Kazumasa Shimomura
git config user.email s2mr@users.noreply.github.com

TARGET_BRANCH=$(echo "$COMMENT_BODY" | sed -e 's/\/ota --into \(.*\).*/\1/g')

if [ "$TARGET_BRANCH" != "" ]; then
    git pull
    git checkout "$TARGET_BRANCH"

    git mmmmerge origin/"$PR_BRANCH" --no-ff 2> /tmp/Error

    if [ "$(cat /tmp/Error)" != "" ]; then
        echo "error=$(cat /tmp/Error)" >> "$GITHUB_OUTPUT"
    fi
else
    git commit --allow-empty -m "[ota]${COMMENT_BODY##/ota}"
fi

git push
