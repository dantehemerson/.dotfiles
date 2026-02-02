#!/bin/bash

source ~/.bashrc

set -euxo pipefail

# Dotfiles Post-Installation Test Suite
# This script tests that all commands are available and all files are properly symlinked after dotfiles installation

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$(dirname "${BASH_SOURCE[0]}")/../utils/utils.sh"

# Source test helpers
source "$SCRIPT_DIR/lib/test_helpers.sh"

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

  echo "PATH:\n"

  echo "$PATH" | tr ':' '\n' | column -t

  echo "BASH VERSION : $BASH_VERSION"
  # Set environment variable to indicate we're running the test suite
  export DOTFILES_TEST_SUITE=1

  # Always run common tests
  "$SCRIPT_DIR/tests/common_tests.sh"

  # Run platform-specific tests using the same format as installation scripts
  if [[ "$CURRENT_DISTRO" == "arch" ]]; then
    "$SCRIPT_DIR/tests/arch_tests.sh"
  elif [[ "$CURRENT_OS" == "macos" ]]; then
    "$SCRIPT_DIR/tests/macos_tests.sh"
  else
    echo "❌ Unsupported distro: '$CURRENT_DISTRO'" >&2
    unset DOTFILES_TEST_SUITE
    exit 1
  fi

  # Unset environment variable
  unset DOTFILES_TEST_SUITE
}

# Run the main function with all arguments
main "$@"

echo "✅ All test passed!!!"
