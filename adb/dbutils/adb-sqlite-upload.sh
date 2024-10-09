#!/bin/bash
INPUT_DEVICE=$1
INPUT_PACKAGE=$2
INPUT_FILE_SQL=$3

#set -x
## Sanity checks
## Agument assert
if [ $# -lt 3 ]; then
    echo "No arguments supplied"
    echo "Args: [input device] [input package] [input file]"
    echo "Ex: emulator-5554 com.innerpackage1.app database.sqlite"
    exit 1;
fi

INNER_PATH_EXT="/sdcard/Download"
INNER_FILE_DB="database.sqlite"
#adb shell "run-as ${INPUT_PACKAGE} sh -c \"du databases/database.sqlite \""
#adb -s ${INPUT_DEVICE} -d shell "run-as ${INPUT_PACKAGE} cp databases/${INNER_FILE_DB} ${INNER_PATH_EXT}"
#adb pull "${INNER_PATH_EXT}/${INNER_FILE_DB}"

adb push $INPUT_FILE_SQL $INNER_PATH_EXT
adb -s ${INPUT_DEVICE} -d shell "run-as ${INPUT_PACKAGE} cp ${INNER_PATH_EXT}/$INPUT_FILE_SQL databases/${INNER_FILE_DB}"
