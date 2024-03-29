#!/bin/bash
INPUT_FILE=$1
NEW_NAME=$(echo $1 | sed s/.xml/-format.xml/g)
if [[ $INPUT_FILE == $NEW_NAME ]]; then
  echo "Same name used for output (${INPUT_FILE})! Use file with '.xml' extension"
  exit 1
fi

if [[ -f $INPUT_FILE ]]; then
  echo "Converting ($INPUT_FILE -> $NEW_NAME)..."
else
  echo "File not found (${INPUT_FILE})!"
  exit 1
fi
tidy -xml ${INPUT_FILE} > $NEW_NAME
