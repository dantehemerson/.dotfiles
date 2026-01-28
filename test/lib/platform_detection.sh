#!/bin/bash

# Platform Detection for Dotfiles Tests
# This file contains utilities for detecting the current platform

# Source the main utils for platform detection
source ~/.dotfiles/utils/utils.sh

# Get current platform information
get_platform_info() {
    echo "OS: $CURRENT_OS"
    echo "Architecture: $CURRENT_ARCH"
    echo "Package Manager: $CURRENT_PM"
    echo "Distribution: $CURRENT_DISTRO"
}



