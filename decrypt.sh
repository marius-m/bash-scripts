#!/bin/bash

# Decrypts input file (+base64) contents with AES-256-CBC and a password

#set -x
FILE_IN=$1
if [[ -f $FILE_IN ]]; then
	echo "Converting..."
else
	echo "File not found!"
	exit 1
fi
KEY_PASS="8d7534c9bcb1e2dbb103ff7e5b7f22ef"
KEY_PASS_DIGEST="$(echo -n $KEY_PASS | openssl sha256)"
#KEY_PASS_DIGEST_B64="$(echo -n $KEY_PASS_DIGEST | base64)"
FILE_NOEXT=$(basename "$FILE_IN" | cut -d. -f1)
FILE_OUT="${FILE_NOEXT}.txt.dec"


## Original
echo "==(original)==> ${FILE_IN}"
echo -e "------------------------\n"
cat ${FILE_IN}
echo -e "\n------------------------\n"


## Decrypt
# @param "-a" decodes input directly from b64
# @param "-d" decode mode
openssl aes-256-cbc -d -a -A \
    -in ${FILE_IN} -out ${FILE_OUT} \
    -iv "00000000000000000000000000000000" \
    -K "${KEY_PASS_DIGEST}"
echo "$FILE_IN =(dec: aes256: \"$KEY_PASS\" + b64)> ${FILE_OUT}"
echo -e "------------------------\n"
cat ${FILE_OUT}
echo -e "\n------------------------\n"
