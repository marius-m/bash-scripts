#!/bin/bash
INPUT_DEVICE=$1
INPUT_PACKAGE=$2

#set -x
## Sanity checks
## Agument assert
if [ $# -lt 2 ]; then
    echo "No arguments supplied"
    echo "Args: [input device] [input package]"
    echo "Ex: emulator-5554 com.innerpackage1.app"
    exit 1;
fi

INNER_PATH_EXT="/sdcard/Download"
INNER_FILE_DB="database.sqlite"
#adb shell "run-as ${INPUT_PACKAGE} sh -c \"du databases/database.sqlite \""
adb -s ${INPUT_DEVICE} -d shell "run-as ${INPUT_PACKAGE} cp databases/${INNER_FILE_DB} ${INNER_PATH_EXT}"
adb pull "${INNER_PATH_EXT}/${INNER_FILE_DB}"
