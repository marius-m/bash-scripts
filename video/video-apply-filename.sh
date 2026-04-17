#!/bin/bash

## Inputs
IN_FILE=$1
OUT_DIR=$2

export LANG=en_US.UTF-8
set -x
## Sanity checks
## Agument assert
if [ $# -lt 2 ]; then
  echo "No arguments supplied"
  echo "Args: [input file] [output directory path]"
  exit 1;
fi


if [[ ! -f $IN_FILE ]]; then
  echo "Input file not found!"
  exit 1;
fi

if [ ! -d $OUT_DIR ]; then
  echo "No valid output directory"
  exit 1;
fi

IN_FILENAME=$(basename -- "$IN_FILE")
IN_EXT="${IN_FILENAME##*.}"
IN_FILENAME="${IN_FILENAME%.*}"
OUT_FILE="${IN_FILENAME}.${IN_EXT}"

# Check if the filename is not empty
if [ -z "$IN_FILENAME" ] && [ -n "$IN_EXT" ]; then
  echo "Filename is empty (${IN_FILENAME}, ${IN_EXT})"
  exit 1;
fi

## Doing conversion
FFMPEG_VF="drawtext=text='${IN_FILENAME}':x=10:y=10:fontcolor=white:fontsize=12"

echo "${IN_FILE} -> ${OUT_DIR}/${OUT_FILE}"
ffmpeg -i "$IN_FILE" -vf "${FFMPEG_VF}" -codec:a copy "${OUT_DIR}/${OUT_FILE}"
