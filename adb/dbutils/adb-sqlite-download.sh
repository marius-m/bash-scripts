#!/bin/bash


## Initial properties
INPUT_FILE_PROPS=sqlite.properties
INPUT_DEVICE=""
INPUT_PACKAGE=""
FILE_SQLITE=""
OPEN_WITH=""
DEFAULT_FILE_SQLITE=database.sqlite

SELF_FILE="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
HELP_SAMPLE="Ex:./${SELF_FILE} --device emulator-5554 --package com.innerpackage1.app --dbfile database.sqlite --openwith /Applications/DBApp.app"

## Reading input vals from properties file if available
if [ -f ${INPUT_FILE_PROPS} ]; then
  echo "Found ${INPUT_FILE_PROPS}. Reading props"
  source sqlite.properties
  INPUT_DEVICE=$device
  INPUT_PACKAGE=$package
  FILE_SQLITE=$dbfile
  OPEN_WITH=$openwith
fi

## Reading ADB devices to provide first available device
ARR_DEVICES=()
adb devices | while read -r line
do
  if [ ! "$line" = "" ] && [ "$(echo "$line" | awk '{print $2}')" = "device" ]
  then
    device=$(echo "$line" | awk '{print $1}')
    echo "Device ${device}"
    ARR_DEVICES+=($device)
  fi
done
echo "Available devices: ${ARR_DEVICES[*]}"

## Reading named arguments and mapping to respective variables as override values
while [ $# -gt 0 ]; do
    if [[ $1 == "--"* ]]; then
        v="${1/--/}"
        declare "$v"="$2"
        shift
    fi
    shift
done
INPUT_DEVICE=$device
INPUT_PACKAGE=$package
FILE_SQLITE=$dbfile
OPEN_WITH=$openwith

## Sanity checks for all necessary variables
if [[ -z "${INPUT_DEVICE}" ]]; then
  echo "Device not found. Please provide as 'device' arg."
  echo $HELP_SAMPLE
  exit 1
fi

if [[ -z "${INPUT_PACKAGE}" ]]; then
  echo "Package not provided. Please provide as a 'package' arg."
  echo $HELP_SAMPLE
  exit 1
fi

if [[ -z "${FILE_SQLITE}" ]]; then
  FILE_SQLITE=$DEFAULT_FILE_SQLITE
fi

echo "Downloading database with"
echo " --device: ${INPUT_DEVICE}"
echo " --package: ${INPUT_PACKAGE}"
echo " --dbfile: ${FILE_SQLITE}"
echo " --openwith: ${OPEN_WITH}"
INNER_PATH_EXT="/sdcard/Download"
INNER_FILE_DB=${FILE_SQLITE}
## Attempt 1 ('/sdcard' not reachable due permissions on real revice)
#adb -s ${INPUT_DEVICE} -d shell "run-as ${INPUT_PACKAGE} cp databases/${INNER_FILE_DB} ${INNER_PATH_EXT}"
#adb -s ${INPUT_DEVICE} pull "${INNER_PATH_EXT}/${INNER_FILE_DB}"

## Attempt 2
echo "- Inspecting root folder"
adb -s ${INPUT_DEVICE} exec-out "run-as ${INPUT_PACKAGE} ls -la"

echo "- Inspecting databases folder"
adb -s ${INPUT_DEVICE} exec-out "run-as ${INPUT_PACKAGE} ls -la databases"

echo "- Pulling database file to local storage (${INNER_FILE_DB})"
adb -s ${INPUT_DEVICE} exec-out "run-as ${INPUT_PACKAGE} cat databases/${INNER_FILE_DB}" > ${INNER_FILE_DB}

if [[ -z "${OPEN_WITH}" ]]; then
  echo "No app provided to 'open with'. Skipping open."
  exit 1
fi
open -a ${OPEN_WITH} ${INNER_FILE_DB}
