#!/bin/bash
INPUT_PATH=$1
OUTPUT_PATH=$2

#set -x
## Sanity checks
## Agument assert
if [ $# -lt 2 ]; then
    echo "No arguments supplied"
    echo "Args: [input path] [output path]"
    exit 1;
fi

## Paths asserts
if [ ! -d ${INPUT_PATH} ]; then
  echo "Input directory doesnt exist. (${INPUT_PATH})"
  exit 1;
fi
if [ ! -d ${INPUT_PATH} ]; then
  echo "Output directory doesnt exist. (${OUTPUT_PATH})"
  exit 1;
fi

whoami
cd ${INPUT_PATH}
echo "Inspecting path: '${INPUT_PATH}'"
FILES_ORG_ALL=($(grep -rl --include="*.org" "" .))
FILES_ORG_ALL_SIZE=${#FILES_ORG_ALL[@]}

### Listing out files exclusion files
echo "Finding :work: files.."
FILES_ORG_WORK=($(grep -rl --include="*.org" ":work:" .))
FILES_ORG_WORK_SIZE=${#FILES_ORG_WORK[@]}
echo "Found ${FILES_ORG_WORK_SIZE} / ${FILES_ORG_ALL_SIZE} results"

#echo "Writing 'exclude.txt' for :work: exclusions"
#FILE_EXCLUDE=exclude.txt
#printf "%s\n" "${FILES_ORG_WORK[@]}" > ${FILE_EXCLUDE}
#FILE_EXCLUDE_FULL=$(realpath $FILE_EXCLUDE)

## Appending exclusion files
echo "Gathering exclusion files.."
FILE_EX=exclude.txt
echo "" > $FILE_EX
RSYNC_ARG_FILE_EXCLUDE=()
for item in "${FILES_ORG_WORK[@]}"; do
    #ITEM_PATH_FULL=$(realpath $item)
    #ITEM_PATH_FULL=$(basename $item)
    ITEM_PATH_FULL=${item:2:${#item}}
    #RSYNC_ARG_FILE_EXCLUDE="$RSYNC_ARG_FILE_EXCLUDE --exclude='${ITEM_PATH_FULL}'"
    echo $ITEM_PATH_FULL >> $FILE_EX
done

echo "Synchroning files.."
rsync -avhru --progress --exclude-from=$FILE_EX --exclude=$FILE_EX . ${OUTPUT_PATH}
echo "Done."
