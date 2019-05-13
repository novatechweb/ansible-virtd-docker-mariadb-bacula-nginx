#!/bin/bash
set -e

CONFIGCMD="git config --file .gitsubtrees"
DEFBRANCH="master"

if [ $# == 0 ]; then
    subtrees=$($CONFIGCMD --name-only --get-regexp 'subtree\..*\.remote' 2>/dev/null | cut -d. -f2)
    set -- $subtrees
fi

git tag -f 'pre-import'
for st in "$@"; do
    st="${st%/}"

    echo "***** Adding subtree at prefix $st"

    if ! branch=$($CONFIGCMD --get subtree."$st".branch 2>/dev/null); then
        $CONFIGCMD subtree."$st".branch "$DEFBRANCH"
        branch="$DEFBRANCH"
    fi

    if ! remote=$($CONFIGCMD --get subtree."$st".remote 2>/dev/null); then
        printf "...subtree has no remote configured.\n...skipped.\n\n"
        continue
    fi

    git subtree add --prefix="${st}" --message="${st}: Add subtree" "${remote}" "${branch}"

    echo "********************************************************************************"
    echo
done
