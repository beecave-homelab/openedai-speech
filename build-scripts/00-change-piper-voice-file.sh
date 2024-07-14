#!/bin/sh
# Script to modify the voice.py file to change the providers line

# Check if PYTHON_VERSION argument is provided
if [ -z "$1" ]; then
    echo "Error: PYTHON_VERSION argument not provided!"
    exit 1
fi

PYTHON_VERSION=$1
VOICE_FILE="/usr/local/lib/python${PYTHON_VERSION}/site-packages/piper/voice.py"

# Check if the voice.py file exists
if [ ! -f "$VOICE_FILE" ]; then
    echo "Error: $VOICE_FILE not found!"
    exit 1
fi

# Use sed to perform the replacement
sed -i 's/providers=\["CPUExecutionProvider"\] if not use_cuda else \["CUDAExecutionProvider"\],/providers=\["MIGraphXExecutionProvider"\],/g' "$VOICE_FILE"

# Check if the sed command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to modify $VOICE_FILE"
    exit 1
fi

echo "Modification applied to $VOICE_FILE"