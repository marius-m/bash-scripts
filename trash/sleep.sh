#!/bin/bash
DURATION=$1
if [[ ! -z $FILE ]]; then
	echo "No duration..."
	exit 1
fi
echo "Sleeping for ${DURATION}s"
sleep $DURATION
