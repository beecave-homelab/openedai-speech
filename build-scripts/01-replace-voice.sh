#!/bin/bash

#==============================================================================
# SCRIPT: replace_voice.sh
# AUTHOR: Your Name
# DATE: YYYY-MM-DD
# REV: 1.0
# PLATFORM: Unix/Linux
# PURPOSE: Replace original voice.py with modified version and set permissions
#==============================================================================

#--------------------------------------
# VARIABLES
#--------------------------------------
SCRIPT_NAME=$(basename "$0")
VERSION="1.0"
LOGFILE="/var/log/${SCRIPT_NAME}.log"
MODIFIED_VOICE_FILE="/app/build-scripts/modified-voice.py"
ORIGINAL_VOICE_FILE="/usr/local/lib/python3.10/site-packages/piper/voice.py"

#--------------------------------------
# FUNCTIONS
#--------------------------------------

# Function: display_help
# Displays the help information
display_help() {
    echo "Usage: $SCRIPT_NAME [options]"
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

# Function: replace_voice_file
# Replaces the original voice.py with the modified version and sets permissions
replace_voice_file() {
    if [ ! -f "$MODIFIED_VOICE_FILE" ]; then
        error_exit "Modified voice.py file not found at $MODIFIED_VOICE_FILE"
    fi

    cp "$MODIFIED_VOICE_FILE" "$ORIGINAL_VOICE_FILE" || error_exit "Failed to copy $MODIFIED_VOICE_FILE to $ORIGINAL_VOICE_FILE"
    chmod 644 "$ORIGINAL_VOICE_FILE" || error_exit "Failed to set permissions on $ORIGINAL_VOICE_FILE"
    log_message "Replaced voice.py with the modified version."
    echo "Replaced voice.py with the modified version."
}

#--------------------------------------
# MAIN SCRIPT
#--------------------------------------

# Default action
default_action() {
    log_message "Starting replacement of voice.py."
    replace_voice_file
    log_message "Completed replacement of voice.py."
}

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
        *)  # No more options
            break
            ;;
    esac
    shift
done

# If no arguments are provided, run the default action
if [ "$#" -eq 0 ]; then
    default_action
else
    # If arguments are provided, continue with the script (arguments were already parsed)
    log_message "Starting replacement of voice.py."
    replace_voice_file
    log_message "Completed replacement of voice.py."
fi

exit 0