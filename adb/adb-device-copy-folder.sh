#!/bin/bash

### Copy folder from app package (requires root) 
#
# ./adb-copy-folder.sh [app-package-name] [log-folder]
# Ex: ./adb-copy-folder.sh lt.markmerkk.blindless.app.debug databases

#set -x

INPUT_PACKAGE=$1
INPUT_FOLDER=$2
if [[ -z ${INPUT_PACKAGE} || -z ${INPUT_FOLDER} ]] ; then
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
# adb shell run-as $TARGET_PACKAGE "sh -c \"ls ./${TARGET_FOLDER}\""
echo "- Traversing files"
ADB_FILES=($(adb shell run-as $TARGET_PACKAGE "sh -c \"ls ./${TARGET_FOLDER}\""))
for ADB_FILE in "${ADB_FILES[@]}"
do
  echo "-- ${ADB_FILE}"
done
echo "- Copy? y/n"

read CONFIRM
[ "$CONFIRM" != "y" ] && echo "- Cancelled" && exit 1

## Moving logs to tmp path
echo "- Copying(${TARGET_PACKAGE}/${TARGET_FOLDER} to ${TMP_PATH_FULL})"
for ADB_FILE in "${ADB_FILES[@]}"
do
  echo "-- Copying(${ADB_FILE})"
  adb shell run-as $TARGET_PACKAGE "sh -c \"cat ./${TARGET_FOLDER}/${ADB_FILE}\"" > $ADB_FILE
  STATUS=$?
  [ $STATUS -eq 0 ] && echo "-- Success"
done
