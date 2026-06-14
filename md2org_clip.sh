#!/bin/zsh
FILE=$1
NEW_NAME=$(echo "$1" | sed 's/\.md$/.org/')

if [[ ! -f "$FILE" ]]; then
    echo "File not found: $FILE"
    exit 1
fi

echo "Converting: $FILE"
pandoc -f markdown-auto_identifiers -t org --wrap=none -o "${FILE}.org" "${FILE}"

echo "Renaming to: $NEW_NAME"
mv "${FILE}.org" "${NEW_NAME}"

echo "Copying to clipboard..."
cat "${NEW_NAME}" | pbc
echo "Done. Org content copied to clipboard."
