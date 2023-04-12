#!/bin/bash

INPUT_PACKAGE=$1
INPUT_FOLDER=$2
if [[ -z ${INPUT_PACKAGE} && -z ${INPUT_FOLDER} ]] ; then
    echo "./copy-logs.sh [app-package-name] [log-folder]"
    exit 1
fi

TMP_PATH="/sdcard/Download"
TARGET_PACKAGE=${INPUT_PACKAGE}
TARGET_FOLDER=${INPUT_FOLDER}

## Moving logs to tmp path
echo "- Moving ${TARGET_FOLDER}:${TARGET_FOLDER} to ${TMP_PATH}"
adb shell su 0 "cp -r /data/data/${TARGET_PACKAGE}/files/${TARGET_FOLDER} ${TMP_PATH}"

STATUS=$?
[ $STATUS -ne 0 ] && echo "Copy failure" && exit 1

echo "- Pulling last tmp files"
adb pull "$TMP_PATH/$TARGET_FOLDER"
adb shell rm -r "${TMP_PATH}/$TARGET_FOLDER"

STATUS=$?
[ $STATUS -eq 0 ] && echo "Success downloading logs!"
