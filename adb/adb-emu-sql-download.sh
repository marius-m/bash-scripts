#!/bin/bash
#
# !!! Incomplete !!!
#

INPUT_PACKAGE=$1
if [[ -z ${INPUT_PACKAGE} ]] ; then
    echo "./adb-emu-sql-download.sh [package]"
    echo "Ex: ./adb-emu-download.sh com.package.app"
    exit 1
fi
#adb shell "run-as ${INPUT_PACKAGE} sh -c \"du databases/database.sqlite \""
adb -d shell "run-as ${INPUT_PACKAGE} cp databases/database.sqlite /sdcard/Download/"
