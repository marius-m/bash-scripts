#!/bin/bash
INPUT_FILE_SQLITE=$1

SELF_FILE="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
#set -x
## Sanity checks
## Agument assert
if [ $# -lt 1 ]; then
    echo "No arguments supplied"
    echo "Args: [file.sqlite]"
    echo "Ex: ./${SELF_FILE} database.sqlite"
    exit 1;
fi
open -a ~/Applications/DataGrip.app ${INPUT_FILE_SQLITE}

