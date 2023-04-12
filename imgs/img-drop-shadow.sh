#!/bin/sh
#set -x
FILE=$1
EXT="-shadow"
NEW_NAME=$(echo $1 | sed s/.png/${EXT}.png/g | sed s/.jpg/${EXT}.jpg/g | sed 's/[[:space:]]/-/g')
if [[ -f $FILE ]]; then
	echo "Adding shadow..."
else
	echo "File not found!"
fi
#-reverse -background none -layers merge +repage $NEW_NAME
cp "$FILE" "$NEW_NAME"

#convert "${NEW_NAME}" -bordercolor white -border 13 \( +clone -background black -shadow 80x3+2+2 \) +swap -background white -layers merge +repage $NEW_NAME
#convert -page +4+4 "${NEW_NAME}" -alpha set \( +clone -background navy -shadow 60x8+8+8 \) +swap -background none -mosaic "${NEW_NAME}"
#convert ${NEW_NAME} \( +clone -background black -shadow 30x8+0+0 \) +swap -background none -layers merge +repage ${NEW_NAME}
convert ${NEW_NAME} -bordercolor white -border 13 \( +clone -background black -shadow 80x3+2+2 \) +swap -background white -layers merge +repage ${NEW_NAME}

echo "$FILE => ${NEW_NAME}"
