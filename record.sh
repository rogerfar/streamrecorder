#!/bin/sh

# Parameters
URL=$1
OUTPUT_PATH=$2
FILENAME=$3
RUNTIME=$4

if [ -z "$URL" ] || [ -z "$OUTPUT_PATH" ] || [ -z "$FILENAME" ] || [ -z "$RUNTIME" ]; then
    echo "Error: Missing arguments. Usage: ./record.sh <URL> <OUTPUT_PATH> <FILENAME> <RUNTIME>"
    exit 1
fi

if [ ! -d "$OUTPUT_PATH" ]; then
    echo "Output directory does not exist. Creating: $OUTPUT_PATH"
    mkdir -p "$OUTPUT_PATH"
fi

# Check if directory creation was successful
if [ ! -d "$OUTPUT_PATH" ]; then
    echo "Failed to create output directory: $OUTPUT_PATH"
    exit 1
fi

# Get the current date in DDMMYYYY format
TODAY=$(date +%Y-%m-%d)

# Construct the full output filename
FULL_OUTPUT_FILE="${OUTPUT_PATH}/${TODAY}_${FILENAME}"

echo "Recording $URL for $RUNTIME seconds to $FULL_OUTPUT_FILE"

# Run VLC with parameters
vlc "$URL" vlc://quit --run-time=$RUNTIME --play-and-exit --intf dummy --no-audio --sout="#std{access=file,mux=mp3,dst=$FULL_OUTPUT_FILE}"

echo "Recording complete"