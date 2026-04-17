#!/bin/bash
INPUT_PATH=$1
OUTPUT_PATH=$2

#set -x
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
echo ""
## Paths asserts
if [ ! -d ${INPUT_PATH} ]; then
  echo "Input directory doesnt exist. (${INPUT_PATH})"
  exit 1;
fi
if [ ! -d ${OUTPUT_PATH} ]; then
  echo "Output directory doesnt exist. (${OUTPUT_PATH})"
  exit 1;
fi

ESCAPED_INPUT=$(printf '%s' "${INPUT_PATH}" | sed 's/ /\\ /g')
ESCAPED_OUTPUT=$(printf '%s' "${OUTPUT_PATH}" | sed 's/ /\\ /g')

whoami
eval cd "${ESCAPED_INPUT}"
echo "Inspecting path: '${INPUT_PATH}'"
FILES_ORG_ALL=($(grep -rl --include="*.org" "" .))
FILES_ORG_ALL_SIZE=${#FILES_ORG_ALL[@]}

### Listing out files exclusion files
echo "Finding :work: files.."
FILES_ORG_WORK=($(grep -rl --include="*.org" ":work:" .))
FILES_ORG_WORK_SIZE=${#FILES_ORG_WORK[@]}
echo "Found work:${FILES_ORG_WORK_SIZE} / all:${FILES_ORG_ALL_SIZE} results"

#echo "Writing 'exclude.txt' for :work: exclusions"
#FILE_EXCLUDE=exclude.txt
#printf "%s\n" "${FILES_ORG_WORK[@]}" > ${FILE_EXCLUDE}
#FILE_EXCLUDE_FULL=$(realpath $FILE_EXCLUDE)

## Appending exclusion files
echo "Gathering exclusion files.."
FILE_EX=exclude.txt
> $FILE_EX
RSYNC_ARG_FILE_EXCLUDE=()
for item in "${FILES_ORG_WORK[@]}"; do
    #ITEM_PATH_FULL=$(realpath $item)
    #ITEM_PATH_FULL=$(basename $item)
    ITEM_PATH_FULL=${item:2:${#item}}
    #RSYNC_ARG_FILE_EXCLUDE="$RSYNC_ARG_FILE_EXCLUDE --exclude='${ITEM_PATH_FULL}'"
    echo $ITEM_PATH_FULL >> $FILE_EX
done
echo "*.org_archive" >> $FILE_EX

echo "Synchroning files.. (from: '${INPUT_PATH}', to: '${OUTPUT_PATH}')"
eval rsync -avhru --progress --exclude-from=$FILE_EX --exclude=$FILE_EX "${ESCAPED_INPUT}" "${ESCAPED_OUTPUT}"
echo "Done."
