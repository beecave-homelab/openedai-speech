#!/bin/bash

# Define the path to the modified voice.py
MODIFIED_VOICE_FILE="/app/build-scripts/modified_voice.py"

# Define the path to the original voice.py
ORIGINAL_VOICE_FILE="/usr/local/lib/python3.10/site-packages/piper/voice.py"

# Check if the modified voice.py exists
if [ ! -f "$MODIFIED_VOICE_FILE" ]; then
  echo "Modified voice.py file not found at $MODIFIED_VOICE_FILE"
  exit 1
fi

# Replace the original voice.py with the modified version
cp $MODIFIED_VOICE_FILE $ORIGINAL_VOICE_FILE

# Set the appropriate permissions
chmod 644 $ORIGINAL_VOICE_FILE

echo "Replaced voice.py with the modified version."