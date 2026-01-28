#!/bin/bash

# Dotfiles Post-Installation Test Suite
# This script tests that all commands are available and all files are properly symlinked after dotfiles installation

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/lib/test_helpers.sh"
source "$SCRIPT_DIR/lib/platform_detection.sh"

# Main function to run all tests
main() {
    local run_as=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --run-as)
                run_as="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Set environment variable to indicate we're running the test suite
    export DOTFILES_TEST_SUITE=1
    
    # Get platform information
    get_platform_info
    
    # Always run common tests
    "$SCRIPT_DIR/tests/common_tests.sh"
    
    # Run platform-specific tests using the same format as installation scripts
    if [[ "$CURRENT_DISTRO" == "arch" ]]; then
        "$SCRIPT_DIR/tests/arch_tests.sh"
    elif [[ "$CURRENT_DISTRO" == "debian" ]]; then
        "$SCRIPT_DIR/tests/debian_tests.sh"
    elif [[ "$CURRENT_DISTRO" == "ubuntu" ]]; then
        "$SCRIPT_DIR/tests/ubuntu_tests.sh"
    elif [[ "$CURRENT_OS" == "macos" ]]; then
        "$SCRIPT_DIR/tests/macos_tests.sh"
    else
        echo "❌ Unsupported distro: '$CURRENT_DISTRO'" >&2
        force_cleanup_test_state
        unset DOTFILES_TEST_SUITE
        exit 1
    fi
    
    # Run omarchy tests if applicable
    if [ -d "$DOTFILES_DIR/omarchy" ] && [ -L "$HOME/.bashrc" ] && [[ "$(readlink "$HOME/.bashrc")" == *"omarchy"* ]] && [ -d "$HOME/.config/hypr" ]; then
        "$SCRIPT_DIR/tests/omarchy_tests.sh"
    fi
    
    # Unset environment variable
    unset DOTFILES_TEST_SUITE
}

# Run the main function with all arguments
main "$@"