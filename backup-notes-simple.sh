#!/bin/bash
INPUT_PATH=$1
OUTPUT_PATH=$2

## Sanity checks
## Argument assert
if [ $# -lt 2 ]; then
    echo "No arguments supplied"
    echo "Args: [input path] [output path]"
    exit 1;
fi

DATE=$(date)
echo ""
echo "**********************************************************************"
echo "                    Initializing backup ($DATE)                       "
echo " - From: '${INPUT_PATH}'"
echo " - To: '${OUTPUT_PATH}'"
echo "**********************************************************************"
echo ""

echo "Synchronizing files.. (from: '${INPUT_PATH}', to: '${OUTPUT_PATH}')"
ESCAPED_INPUT=$(printf '%s' "${INPUT_PATH}" | sed 's/ /\\ /g')
ESCAPED_OUTPUT=$(printf '%s' "${OUTPUT_PATH}" | sed 's/ /\\ /g')
eval rsync -avhru --progress "${ESCAPED_INPUT}" "${ESCAPED_OUTPUT}"
echo "Done."
