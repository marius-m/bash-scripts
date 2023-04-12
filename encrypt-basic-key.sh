#!/bin/bash

# Encrypts input file (+base64) contents with AES-256-CBC and a password

#set -x
FILE_IN=$1
if [[ -f $FILE_IN ]]; then
	echo "Converting..."
else
	echo "File not found!"
	exit 1
fi
KEY_PASS=$SONT_KEY
FILE_NOEXT=$(basename "$FILE_IN" | cut -d. -f1)
FILE_OUT="${FILE_NOEXT}.txt.enc"


## Dependencies
echo "Pass: ${KEY_PASS}"


## Original
echo "==(original)==> ${FILE_IN}"
echo -e "------------------------\n"
cat ${FILE_IN}
echo -e "\n------------------------\n"


## Encrypt
# @param "-a" encodes output directly to b64
# @param "-e" encode mode
# @param "-p" preview
# @param "-k" key password

tr -d '\n' < $FILE_IN | openssl aes-256-cbc -e -a -A \
    -out ${FILE_OUT} \
    -k "${KEY_PASS}" \
    -iv "0000000000000000" \
    -p
echo "$FILE_IN ==(enc: aes256: \"$KEY_PASS\" + b64)=> ${FILE_OUT}"
echo -e "------------------------\n"
cat ${FILE_OUT}
echo -e "\n------------------------\n"
