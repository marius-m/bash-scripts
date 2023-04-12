#!/bin/bash

#set -x
FILE_IN=$1
if [[ ! -f $FILE_IN ]]; then
    echo "Input file not found!"
exit 1
fi
if [[ $FILE_IN != *.json ]]; then
    echo "Input file not json!"
    exit 1
fi
FILE_OUT_NAME=$(echo "${FILE_IN}" | sed s/.json/.txt/)
FILE_OUT=$FILE_OUT_NAME
if [[ ! -f $FILE_OUT ]]; then
    echo "Creating out file: '${FILE_OUT}'"
    touch $FILE_OUT
fi
echo "Reading quotes from ${FILE_IN}"
OUT=$(cat ${FILE_IN} | jq ".data[] | .quote + \" \" + .author")
IFS=$'\n' read -r -d '' -a OUT_ARRAY <<< "$OUT"

i=0
size=${#OUT_ARRAY[@]}
echo "Found ${size} quotes"
echo "Recording quotes to ${FILE_OUT}"
for (( i=0; i<$size; i++ )) ; do
    QUOTE=$(echo ${OUT_ARRAY[$i]} | tr -d '"')
    echo "${QUOTE}" >> $FILE_OUT
    echo -e "%" >> $FILE_OUT
done

echo "Converting quotes (${FILE_OUT})"
strfile -c % $FILE_OUT
