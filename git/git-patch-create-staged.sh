#!/bin/bash
# Source: https://stackoverflow.com/questions/5159185/create-a-git-patch-from-the-uncommitted-changes-in-the-current-working-directory
FILE_OUT=$1
if [[ ! -f $FILE_OUT ]]; then
    echo "Input file not found! Creating new one."
    touch ${FILE_OUT}
fi
echo "Storing staged changes to ${FILE_OUT}"
git diff --cached --binary > ${FILE_OUT}
