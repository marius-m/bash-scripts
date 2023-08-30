#!/bin/bash

### Copy folder from app package (requires root) 
#
# ./adb-copy-folder.sh [app-package-name] [log-folder]
# Ex: ./adb-copy-folder.sh lt.markmerkk.blindless.app.debug databases

INPUT_PACKAGE=$1
INPUT_FOLDER=$2
if [[ -z ${INPUT_PACKAGE} && -z ${INPUT_FOLDER} ]] ; then
    echo "./adb-copy-folder.sh [app-package-name] [log-folder]"
    echo "Ex: ./adb-copy-folder.sh lt.markmerkk.blindless.app.debug databases"
    exit 1
fi

TMP_PATH="/sdcard/Download"
TMP_FOLDER=$(uuidgen)
TMP_PATH_FULL="${TMP_PATH}/${TMP_FOLDER}"
TARGET_PACKAGE=${INPUT_PACKAGE}
TARGET_FOLDER=${INPUT_FOLDER}

## List folder contents
echo "- List files(${TARGET_PACKAGE}/${TARGET_FOLDER})"
adb shell su 0 "ls -la /data/data/${TARGET_PACKAGE}/${TARGET_FOLDER}"

echo "- Copy? y/n"

read CONFIRM
[ "$CONFIRM" != "y" ] && echo "- Cancelled" && exit 1

## Moving logs to tmp path
echo "- Copying(${TARGET_PACKAGE}/${TARGET_FOLDER} to ${TMP_PATH_FULL})"
adb shell su 0 "cp -r /data/data/${TARGET_PACKAGE}/${TARGET_FOLDER} ${TMP_PATH_FULL}"

STATUS=$?
[ $STATUS -ne 0 ] && echo "- Copy failure" && exit 1

echo "- Pulling files($TMP_PATH_FULL)"
adb pull "$TMP_PATH_FULL"
echo "- Clean up($TMP_PATH_FULL)"
adb shell rm -r "${TMP_PATH_FULL}"

STATUS=$?
[ $STATUS -eq 0 ] && echo "- Success"

## Rename results
RESULT_DATE=$(date "+%Y-%m-%d %H:%M:%S")
RESULT_DIR="${TARGET_PACKAGE}_${TARGET_FOLDER}_$RESULT_DATE"
echo "- Rename results($RESULT_DIR)"
mv ${TMP_FOLDER} "${RESULT_DIR}"

STATUS=$?
[ $STATUS -eq 0 ] && echo "- Success"
