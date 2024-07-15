#!/bin/bash

# Function to install a Python package if not already installed
install_if_not_present() {
    package=$1
    version=$2
    if ! pip show "$package" | grep -q "Version: $version"; then
        pip install "$package==$version"
    else
        echo "$package $version is already installed."
    fi
}
# Uninstall the existing onnxruntime package if it exists
pip show onnxruntime && pip uninstall -y onnxruntime
# Install onnxruntime with ROCm support from the specified URL
onnxruntime_url="https://repo.radeon.com/rocm/manylinux/rocm-rel-6.1.3/onnxruntime_rocm-1.17.0-cp310-cp310-linux_x86_64.whl"
pip install "$onnxruntime_url"

# Install specific versions of numpy and protobuf if not already installed
install_if_not_present numpy 1.26.4
install_if_not_present protobuf 4.25.3
