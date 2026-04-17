#!/bin/sh

## Fetching script location
## Source: https://www.baeldung.com/linux/bash-get-location-within-script
SCRIPT_PATH="${BASH_SOURCE}"
while [ -L "${SCRIPT_PATH}" ]; do
  TARGET="$(readlink "${SCRIPT_PATH}")"
  if [[ "${TARGET}" == /* ]]; then
    SCRIPT_PATH="$TARGET"
  else
    SCRIPT_PATH="$(dirname "${SCRIPT_PATH}")/${TARGET}"
  fi
done
SCRIPT_PATH=$(dirname ${SCRIPT_PATH})

## Move to skull folder
RANDOM_SKULL_LN=random-skull.txt
REPO_DIR=${SCRIPT_PATH}/ascii-all
cd $SCRIPT_PATH

## Array of skulls
## Add all skulls to array from 'find function'
FILES=()
find ${REPO_DIR} -name "*.txt" -print0 >tmpfile
while IFS=  read -r -d $'\0'; do
  FILES+=("$REPLY")
done <tmpfile
rm -f tmpfile

## Pick random skull from repo
FILE_LENGTH_INDEX=0
FILE_LENGTH=${#FILES[@]}
((FILE_LENGTH_INDEX=${FILE_LENGTH}-1))
RANDOM_SKULL_NUM=$(shuf -i "0-${FILE_LENGTH_INDEX}" -n 1)
RANDOM_SKULL=${FILES[${RANDOM_SKULL_NUM}]}

#echo "Random skull: ${RANDOM_SKULL} (${RANDOM_SKULL_NUM}) (${FILE_LENGTH_INDEX})"

## Rm old symlink
rm ${RANDOM_SKULL_LN}
#echo "Using ${RANDOM_SKULL} -> (${RANDOM_SKULL_LN})"
ln -s $RANDOM_SKULL ${RANDOM_SKULL_LN}
