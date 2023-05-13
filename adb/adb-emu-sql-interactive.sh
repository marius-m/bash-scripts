#!/bin/bash
#
# !!! Incomplete !!!
#

INPUT_PACKAGE=$1
if [[ -z ${INPUT_PACKAGE} ]] ; then
    echo "./adb-emu-sql-interactive.sh [package]"
    echo "Ex: ./adb-emu-interactive.sh com.package.app"
    exit 1
fi
while true; do
    echo - Query:
    read query
    #adb shell su 0 sqlite3 -line data/data/${INPUT_PACKAGE}/databases/database.sqlite "\"$query"\"
    adb shell "run-as ${INPUT_PACKAGE} sqlite3 -line databases/database.sqlite "\"$query"\" "
done
