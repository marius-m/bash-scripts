#!/bin/bash
INPUT_FILE=$1
NEW_NAME=$(echo $1 | sed s/.json/-format.json/g)
if [[ $INPUT_FILE == $NEW_NAME ]]; then
  echo "Same name used for output (${INPUT_FILE})! Use file with '.json' extension"
  exit 1
fi

if [[ -f $INPUT_FILE ]]; then
  echo "Converting..."
else
  echo "File not found (${INPUT_FILE})!"
  exit 1
fi
cat ${INPUT_FILE} | jq > ${NEW_NAME}
