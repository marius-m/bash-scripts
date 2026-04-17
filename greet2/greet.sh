#!/bin/sh

TIME=$(date "+%H")
TIME_OF_DAY="Mornin'"
if [ $TIME -lt 12 ]; then
    TIME_OF_DAY="Mornin'"
elif [ $TIME -lt 18 ]; then
    TIME_OF_DAY="Afternoon"
else
    TIME_OF_DAY="Evenin'"
fi
echo $TIME_OF_DAY
