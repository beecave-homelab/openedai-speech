#!/bin/bash

#==============================================================================
# SCRIPT: 00-change-piper-voice-file.sh
# AUTHOR: elvee
# DATE: 15-07-2024
# REV: 1.0
# PLATFORM: Unix/Linux
# PURPOSE: Modify the voice.py file to change the providers line
#==============================================================================

#--------------------------------------
# VARIABLES
#--------------------------------------
SCRIPT_NAME=$(basename "$0")
VERSION="1.0"
LOGFILE="/var/log/${SCRIPT_NAME}.log"

#--------------------------------------
# FUNCTIONS
#--------------------------------------

# Function: display_help
# Displays the help information
display_help() {
    echo "Usage: $SCRIPT_NAME [PYTHON_VERSION]"
    echo
    echo "Arguments:"
    echo "  PYTHON_VERSION    Specify the Python version (e.g., 3.10)"
    echo
    echo "Options:"
    echo "  -h, --help        Show this help message and exit"
    echo "  -v, --version     Show script version and exit"
    echo
}

# Function: log_message
# Logs a message to the logfile
log_message() {
    local MESSAGE="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") : $MESSAGE" >> "$LOGFILE"
}

# Function: error_exit
# Display an error message and exit
error_exit() {
    echo "$1" 1>&2
    log_message "ERROR: $1"
    exit 1
}

# Function: modify_voice_file
# Modify the voice.py file to change the providers line
modify_voice_file() {
    local PYTHON_VERSION=$1
    local VOICE_FILE="/usr/local/lib/python${PYTHON_VERSION}/site-packages/piper/voice.py"

    if [ ! -f "$VOICE_FILE" ]; then
        error_exit "Error: $VOICE_FILE not found!"
    fi

    sed -i 's/providers=\["CPUExecutionProvider"\] if not use_cuda else \["CUDAExecutionProvider"\],/providers=\["MIGraphXExecutionProvider"\],/g' "$VOICE_FILE"

    if [ $? -ne 0 ]; then
        error_exit "Error: Failed to modify $VOICE_FILE"
    fi

    log_message "Modification applied to $VOICE_FILE"
    echo "Modification applied to $VOICE_FILE"
}

#--------------------------------------
# MAIN SCRIPT
#--------------------------------------

# Check if no arguments were passed
if [ "$#" -eq 0 ]; then
    display_help
    exit 1
fi

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)
            display_help
            exit 0
            ;;
        -v|--version)
            echo "$SCRIPT_NAME version $VERSION"
            exit 0
            ;;
        --) # End of all options
            shift
            break
            ;;
        -*)
            error_exit "Error: Unknown option $1"
            ;;
        *)  # Assume the remaining argument is PYTHON_VERSION
            PYTHON_VERSION="$1"
            shift
            ;;
    esac
done

# Ensure PYTHON_VERSION is set
if [ -z "$PYTHON_VERSION" ]; then
    error_exit "Error: PYTHON_VERSION argument not provided!"
fi

# Log the start of the modification process
log_message "Starting modification of voice.py for Python version $PYTHON_VERSION."

# Modify the voice.py file
modify_voice_file "$PYTHON_VERSION"

# Log the end of the modification process
log_message "Completed modification of voice.py for Python version $PYTHON_VERSION."

exit 0
