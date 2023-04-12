#!/bin/bash
FILE=$1
if [[ -f $FILE ]]; then
	echo "Opening file..."
else
	echo "File not found!"
fi
/usr/local/bin/emacsclient $FILE &
