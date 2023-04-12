#!/bin/bash
# Source: https://www.mscharhag.com/software-development/pandoc-markdown-to-pdf
#set -x
FILE_IN=$1
if [[ ! -f $FILE_IN ]]; then
    echo "Input file not found!"
    exit 1
fi
if [ "${FILE_IN: -3}" != ".md" ]
then
    echo "Input file must be markdown!"
    exit 1
fi
FILE_OUT="${FILE_IN%.*}.pdf"
echo "Converting MD (${FILE_IN}) to PDF (${FILE_OUT})"
pandoc -s -o "$FILE_OUT" "$FILE_IN"
