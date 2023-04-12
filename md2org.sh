#!/bin/bash
FILE=$1
NEW_NAME=$(echo $1 | sed s/.md/.org/g)
if [[ -f $FILE ]]; then
	echo "Converting..."
else
	echo "File not found!"
fi
echo "Converting: $FILE"
pandoc -f markdown -t org --wrap=none -o ${FILE}.org ${FILE};
echo "Renaming to: $NEW_NAME"
mv "${FILE}.org" "${NEW_NAME}"
