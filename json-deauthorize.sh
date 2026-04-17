#!/bin/bash
FILE_INPUT=$1
FILE_TMP="tmp.json"
FILE_NEW=$(echo ${FILE_INPUT} | sed s/.json/-deauth.json/g)
if [[ ${FILE_INPUT} == ${FILE_NEW} ]]; then
  echo "Same name used for output (${FILE_INPUT})! Use file with '.json' extension"
  exit 1
fi

if [[ -f $FILE_INPUT ]]; then
  echo "Deauthorizing..."
else
  echo "File not found (${FILE_INPUT})!"
  exit 1
fi
cp ${FILE_INPUT} ${FILE_TMP}
echo "- Deauth description"
jq '.[].description = ""' ${FILE_TMP} | sponge $FILE_TMP
echo "- Deauth URLs"
sed 's/https:\/\/git.shift4payments.com\//https:\/\/git.project1.com\//g' ${FILE_TMP} | sponge ${FILE_TMP}
echo "- Deauth users"
sed 's/ajasiunas/user1/g' ${FILE_TMP} | sponge ${FILE_TMP}
sed 's/Arnoldas Jasiunas/Firstname1 Lastname1/g' ${FILE_TMP} | sponge ${FILE_TMP}
cp ${FILE_TMP} ${FILE_NEW}
rm ${FILE_TMP}
