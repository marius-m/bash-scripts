#!/bin/bash
#
## Initial properties
#set -x

INPUT_DEVICE=""
INPUT_PACKAGE=""
DEFAULT_FILE_SQLITE=database.sqlite
TMP_FILE_SQLITE=$(uuidgen)

SELF_FILE="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
HELP_SAMPLE="Ex:./${SELF_FILE} --device emulator-5554 --package com.innerpackage1.app --dbfile database.sqlite"

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

echo "Hooking on database with"
echo " --device: ${INPUT_DEVICE}"
echo " --package: ${INPUT_PACKAGE}"
echo " --dbfile: ${FILE_SQLITE}"

INNER_FILE_DB=${FILE_SQLITE}

## Attempt 2

while true; do
    #adb -s ${INPUT_DEVICE} exec-out "run-as ${INPUT_PACKAGE} cat databases/${INNER_FILE_DB}" > ${TMP_FILE_SQLITE}

    echo "- Waiting for query: (Empty input for exit)"
    read query
    if [ -z "$query" ]; then
	echo "- Empty query, exitting..."
        break;
    fi
    adb -s ${INPUT_DEVICE} exec-out "run-as ${INPUT_PACKAGE} sqlite3 -line databases/${INNER_FILE_DB} \"${query}\""
done
