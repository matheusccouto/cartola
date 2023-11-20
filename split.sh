#!/bin/bash

# Specify the input file
input_file="bq-results-20231120-224651-1700520439461.json"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file not found: $input_file"
    exit 1
fi

# Create the backlog folder if it doesn't exist
mkdir -p "backlog"

# Read the content from the file and loop through each line
while IFS= read -r line; do
    # Extract _temporada and _rodada values
    temporada=$(echo "$line" | jq -r '._temporada')
    rodada=$(echo "$line" | jq -r '._rodada')

    # Add leading zero to rodada if it is a single digit
    rodada=$(printf "%02d" "$rodada")

    # Write the line to a file based on YEAR-ROUND.json inside backlog folder
    echo "$line" >> "backlog/$temporada-$rodada.json"

done < "$input_file"

echo "Separation completed."
