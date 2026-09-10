#!/bin/sh
#set -x

# Error out if no input files provided
if [ $# -eq 0 ]; then
    echo "Error: no input files provided" >&2
    echo "Usage: $0 <file1.jpg> <file2.jpg> ..." >&2
    exit 1
fi

# Error out if any provided file does not exist
for f in "$@"; do
    if [ ! -f "$f" ]; then
        echo "Error: file not found: $f" >&2
        exit 1
    fi
done

output="output-$(date +%Y%m%d-%H%M%S).jpg"

convert -append "$@" "$output"
echo "Saved: $output"
