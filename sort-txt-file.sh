#!/bin/zsh
export LANG=en_US.UTF-8
set -x

F_INPUT=$1

if [[ -f $F_INPUT ]]; then
  echo "Sorting ($F_INPUT -> $F_OUT)..."
else
  echo "File not found (${F_INPUT})!"
  exit 1
fi

F_NAME=$(basename -- "$F_INPUT")
F_EXT="${F_NAME##*.}"
F_NAME="${F_NAME%.*}"
F_OUT=$(echo $1 | sed s/.$F_EXT/-sorted.$F_EXT/g)
GUID=$(uuidgen)
F_TMP="tmp-${GUID}"

if [[ $F_INPUT == $F_OUT ]]; then
  echo "Same name used for output (${F_INPUT})!"
  exit 1
fi

sort $F_INPUT > $F_TMP && mv $F_TMP $F_OUT
echo "Complete! ($F_OUT)"
