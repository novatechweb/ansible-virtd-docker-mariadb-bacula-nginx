#!/bin/bash
set -e

CONFIGCMD="git config --file .gitsubtrees"
DEFBRANCH="master"

if [ $# == 0 ]; then
    subtrees=$($CONFIGCMD --name-only --get-regexp 'subtree\..*\.remote' 2>/dev/null | cut -d. -f2)
    set -- $subtrees
fi

for st in "$@"; do
    st="${st%/}"

    echo "***** Splitting subtree at prefix $st..."

    if ! branch=$($CONFIGCMD --get subtree."$st".branch 2>/dev/null); then
        $CONFIGCMD subtree."$st".branch "$DEFBRANCH"
        branch="$DEFBRANCH"
    fi

    localbranch="upstream/$st/$branch"
    git branch -D "$localbranch" >/dev/null 2>&1
    git subtree split --prefix="$st" --branch "$localbranch"

    echo "********************************************************************************"
    echo
done
