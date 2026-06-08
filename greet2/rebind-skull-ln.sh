#!/bin/bash

## Fetching script location
## Source: https://www.baeldung.com/linux/bash-get-location-within-script
SCRIPT_PATH="${BASH_SOURCE[0]}"
while [ -L "${SCRIPT_PATH}" ]; do
  TARGET="$(readlink "${SCRIPT_PATH}")"
  if [[ "${TARGET}" == /* ]]; then
    SCRIPT_PATH="$TARGET"
  else
    SCRIPT_PATH="$(dirname "${SCRIPT_PATH}")/${TARGET}"
  fi
done
SCRIPT_PATH="$(dirname "${SCRIPT_PATH}")"

## Move to skull folder
RANDOM_SKULL_LN="random-skull.txt"
REPO_DIR="${SCRIPT_PATH}/ascii-all"
cd "${SCRIPT_PATH}" || exit 1

## Array of skulls
## Add all skulls to array from 'find function'
FILES=()
while IFS= read -r -d ''; do
  FILES+=("$REPLY")
done < <(find "${REPO_DIR}" -name "*.txt" -print0)

## Pick random skull from repo
FILE_LENGTH="${#FILES[@]}"
if (( FILE_LENGTH == 0 )); then
  echo "No skull files found in ${REPO_DIR}" >&2
  exit 1
fi
RANDOM_SKULL_NUM=$(( RANDOM % FILE_LENGTH ))
RANDOM_SKULL="${FILES[${RANDOM_SKULL_NUM}]}"

## Rm old symlink
rm -f "${RANDOM_SKULL_LN}"
ln -s "${RANDOM_SKULL}" "${RANDOM_SKULL_LN}"
