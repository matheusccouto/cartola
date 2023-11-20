#!/bin/bash

S3_URI="s3://cartola-main/partidas"
GCS_URI="gs://cartola/partidas/partidas"

aws s3 sync $S3_URI ./backlog --exclude "*" --include "*.json"

# Iterate through all the JSON files that match the pattern
for file in backlog/*.json; do

    # Get the base filename without the directory
    base=$(basename "$file")

    # Remove extension.
    base="${base%.json}" 

    # Extract the SEASON and ROUND from the filename
    SEASON="${base%-*}"  # Extracts portion before '-'
    ROUND="${base#*-}" # Extracts portion after '-'

    echo Modifying $SEASON-$ROUND

    ROUND="${ROUND#"${ROUND%%[1-9]*}"}"  # Remove leading zero

    # Use jq to update the JSON and overwrite the original file
    jq .partidas $file |
    jq --arg S $SEASON --arg R $ROUND 'map(. + {"_temporada": $S, "_rodada": $R})' |
    jq -c '.[]' > "${file}.tmp"

    mv "${file}.tmp" "$file"

done


# Overwrite the AWS files with the existing from GCP
gsutil -m cp -r  $GCS_URI/*.json backlog


# Iterate through all the JSON files that match the pattern
for file in backlog/*.json; do

    # Get the base filename without the directory
    base=$(basename "$file")

    gcloud storage cp $file $GCS_URI/$base

done