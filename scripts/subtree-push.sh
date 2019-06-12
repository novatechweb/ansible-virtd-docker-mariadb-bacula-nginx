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

    echo "***** Pushing subtree at prefix $st..."

    if ! branch=$($CONFIGCMD --get subtree."$st".branch 2>/dev/null); then
        $CONFIGCMD subtree."$st".branch "$DEFBRANCH"
        branch="$DEFBRANCH"
    fi

    if ! remote=$($CONFIGCMD --get subtree."$st".remote 2>/dev/null); then
        printf "...subtree configuration not found.\n...skipped.\n\n"
        continue
    fi

    if ! pushremote=$($CONFIGCMD --get subtree."$st".push 2>/dev/null); then
        printf "...subtree has no push remote configured.\n...skipped.\n\n"
        continue
    fi

    git subtree push --prefix="$st" "$pushremote" "$branch"

    echo "********************************************************************************"
    echo
done
