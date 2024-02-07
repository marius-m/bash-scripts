#!/bin/zsh
export LANG=en_US.UTF-8

INPUT_FILE=$1
FILENAME=$(basename -- "$INPUT_FILE")
EXT="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"
NEW_NAME=$(echo $1 | sed s/.$EXT/-format.$EXT/g)
if [[ $INPUT_FILE == $NEW_NAME ]]; then
  echo "Same name used for output (${INPUT_FILE})!"
  exit 1
fi

if [[ -f $INPUT_FILE ]]; then
  echo "Converting ($INPUT_FILE -> $NEW_NAME)..."
else
  echo "File not found (${INPUT_FILE})!"
  exit 1
fi
INPUT=$(cat "$INPUT_FILE")
INPUT_FORMAT=$(printf "$INPUT")

/usr/bin/env printf "$INPUT_FORMAT" > $NEW_NAME
cat $NEW_NAME
