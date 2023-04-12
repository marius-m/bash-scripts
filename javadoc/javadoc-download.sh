#!/bin/bash
set -x
INPUT=$1
if [[ $# -eq 0 ]] ; then
    echo "Paste in JavaDoc URL"
    exit 1
fi
echo "Downloading docs ${INPUT}"
wget --no-parent --recursive --level inf --page-requisites --wait=1 $INPUT
