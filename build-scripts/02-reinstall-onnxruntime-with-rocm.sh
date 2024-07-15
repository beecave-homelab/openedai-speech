#!/bin/bash

#==============================================================================
# SCRIPT: 02-reinstall-onnxruntime-with-rocm.sh
# AUTHOR: elvee
# DATE: 15-06-2024
# REV: 1.0
# PLATFORM: Unix/Linux
# PURPOSE: Install specific Python packages with error handling and logging
#==============================================================================

#--------------------------------------
# VARIABLES
#--------------------------------------
SCRIPT_NAME=$(basename "$0")
VERSION="1.0"
LOGFILE="/var/log/${SCRIPT_NAME}.log"
ONNXRUNTIME_URL="https://repo.radeon.com/rocm/manylinux/rocm-rel-6.1.3/onnxruntime_rocm-1.17.0-cp310-cp310-linux_x86_64.whl"
PYTHON_PACKAGES=(
    "numpy:1.26.4"
    "protobuf:4.25.3"
)

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

# Function: install_if_not_present
# Install a Python package if not already installed
install_if_not_present() {
    local PACKAGE=$1
    local VERSION=$2
    if ! pip show "$PACKAGE" | grep -q "Version: $VERSION"; then
        pip install "$PACKAGE==$VERSION" || error_exit "Failed to install $PACKAGE==$VERSION"
        log_message "$PACKAGE $VERSION installed successfully."
    else
        log_message "$PACKAGE $VERSION is already installed."
    fi
}

# Function: install_onnxruntime
# Uninstall existing onnxruntime package if it exists and install the specified version
install_onnxruntime() {
    if pip show onnxruntime > /dev/null; then
        pip uninstall -y onnxruntime || error_exit "Failed to uninstall existing onnxruntime"
        log_message "Uninstalled existing onnxruntime package."
    fi
    pip install "$ONNXRUNTIME_URL" || error_exit "Failed to install onnxruntime from $ONNXRUNTIME_URL"
    log_message "onnxruntime installed successfully from $ONNXRUNTIME_URL."
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
        *)  # No more options
            break
            ;;
    esac
    shift
done

# Log the start of processing
log_message "Starting package installation process."

# Install onnxruntime
install_onnxruntime

# Install specific versions of Python packages
for package in "${PYTHON_PACKAGES[@]}"; do
    IFS=":" read -r name version <<< "$package"
    install_if_not_present "$name" "$version"
done

# Log the end of processing
log_message "Completed package installation process."

exit 0