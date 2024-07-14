#!/bin/sh
# Script to modify the voices.py file to change the providers line

VOICES_FILE="/usr/local/lib/python3.11/site-packages/piper/voices.py"

# Check if the voices.py file exists
if [ ! -f "$VOICES_FILE" ]; then
    echo "Error: $VOICES_FILE not found!"
    exit 1
fi

# Use sed to perform the replacement
sed -i 's/providers=\["CPUExecutionProvider"\]/providers=["MIGraphXExecutionProvider"],/g' "$VOICES_FILE"

# Check if the sed command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to modify $VOICES_FILE"
    exit 1
fi

echo "Modification applied to $VOICES_FILE"