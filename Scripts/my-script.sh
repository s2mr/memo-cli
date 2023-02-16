#!/bin/bash -x

set -u

function error_handler() {
    echo "error=$(cat /tmp/Error)" >> "$GITHUB_OUTPUT"
    exit 1
}

trap error_handler ERR

git config user.name 'Kazumasa Shimomura'
git config user.email s2mr@users.noreply.github.com

TARGET_BRANCH=$(expr "$COMMENT_BODY" : '.*--into \([^ ]*\)')

if [ "$TARGET_BRANCH" != "" ]; then
    git pull 2> /tmp/Error
    git checkout "$TARGET_BRANCH" 2> /tmp/Error
    git merge origin/"$PR_BRANCH" --no-ff -m "[ota] Merge remote-tracking branch 'origin/$PR_BRANCH' into $TARGET_BRANCH" 2> /tmp/Error
else
    git commit --allow-empty -m "[ota]${COMMENT_BODY##/ota}" 2> /tmp/Error
fi

git push
