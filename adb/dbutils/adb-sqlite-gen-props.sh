#!/bin/bash

## (!) Incomplete
## Writes default config to file on execution path
## Will not execute if already exit

FILE="sqlite.properties"

if [[ ! -f $FILE ]]; then
  echo "Configuration file already exist!"
  exit 1
fi

# Function to write properties to file
write_properties() {
    for key in "${!properties[@]}"; do
        echo "$key=${properties[$key]}" >> "$file"
    done
}

touch $FILE

# Initialize associative array to store properties
## (!) Failing due to older bash version upon execution
declare -A props

# Update or add new properties
props["device"]="emulator-5554"
props["package"]="com.package1.app"
props["dbfile"]="database.sqlite"
props["openwith"]="~/Applications/DataGrip.app"

write_properties
