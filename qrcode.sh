#!/bin/bash
#set -x
OUT_NAME=qrencode-$(uuidgen)
OUT_FILEEXT=png
OUT_FILENAME=${OUT_NAME}.${OUT_FILEEXT}
OUT_FILENAME_TXT=${OUT_NAME}-txt.${OUT_FILEEXT}
OUT=/tmp/${OUT_FILENAME}
OUT_TXT=/tmp/${OUT_FILENAME_TXT}
INPUT=$1
if [[ $# -eq 0 ]] ; then
    echo "Paste in QR to generate"
    exit 1
fi

echo "-- Generating QR..."
echo "$INPUT" | qrencode -t PNG -s 5 -o $OUT
LAST_CMD_STATUS=$?
if [[ $LAST_CMD_STATUS -ne 0 ]] ; then
    echo "Error: Could not generate QR code: ${LAST_CMD_STATUS}"
    exit $LAST_CMD_STATUS
fi
convert $OUT -gravity South -pointsize 10 -annotate +0+0 "$INPUT" $OUT_TXT
open $OUT_TXT
