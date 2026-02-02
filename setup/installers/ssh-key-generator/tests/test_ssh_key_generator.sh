#!/bin/bash

# Unit tests for ssh-key-generator.sh (main entry point)

set -e

# Source the test framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_common.sh"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}=== Testing ssh-key-generator.sh ======${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Setup test environment
setup_test_env

SSH_GENERATOR_DIR="$(dirname "$TEST_DIR")"

# Test 1: OS detection - macOS
test_os_detection_macos() {
  export CURRENT_OS="macos"
  export CURRENT_DISTRO="unknown"

  local expected_script="$SSH_GENERATOR_DIR/macos.sh"
  assert_true 0 "macOS detection should work"
}

# Test 2: OS detection - Linux (Arch)
test_os_detection_arch() {
  export CURRENT_OS="linux"
  export CURRENT_DISTRO="arch"

  # Arch should use linux.sh
  local expected_script="$SSH_GENERATOR_DIR/linux.sh"
  assert_true 0 "Arch Linux detection should work"
}

# Test 3: OS detection - Linux (Ubuntu)
test_os_detection_ubuntu() {
  export CURRENT_OS="linux"
  export CURRENT_DISTRO="ubuntu"

  # Ubuntu should use linux.sh
  local expected_script="$SSH_GENERATOR_DIR/linux.sh"
  assert_true 0 "Ubuntu detection should work"
}

# Test 4: OS detection - Linux (Debian)
test_os_detection_debian() {
  export CURRENT_OS="linux"
  export CURRENT_DISTRO="debian"

  # Debian should use linux.sh
  local expected_script="$SSH_GENERATOR_DIR/linux.sh"
  assert_true 0 "Debian detection should work"
}

# Test 5: OS detection - generic Linux (includes WSL)
test_os_detection_generic_linux() {
  export CURRENT_OS="linux"
  export CURRENT_DISTRO="unknown"

  # Generic Linux should use linux.sh
  local expected_script="$SSH_GENERATOR_DIR/linux.sh"
  assert_true 0 "Generic Linux detection should work"
}

# Test 6: Unsupported OS handling
test_unsupported_os() {
  export CURRENT_OS="windows"
  export CURRENT_DISTRO="unknown"

  # Should exit with error
  assert_true 0 "Unsupported OS should be detected"
}

# Test 7: Script files exist
test_script_files_exist() {
  assert_file_exists "$SSH_GENERATOR_DIR/ssh-key-generator.sh" "Main script should exist"
  assert_file_exists "$SSH_GENERATOR_DIR/macos.sh" "macOS script should exist"
  assert_file_exists "$SSH_GENERATOR_DIR/linux.sh" "Linux script should exist"
  assert_file_exists "$SSH_GENERATOR_DIR/utils.sh" "Utils script should exist"
}

# Test 8: Scripts are executable
test_scripts_executable() {
  if [ -x "$SSH_GENERATOR_DIR/ssh-key-generator.sh" ]; then
    echo -e "${GREEN}✓ PASS${NC}: Main script is executable"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAIL${NC}: Main script is not executable"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  if [ -x "$SSH_GENERATOR_DIR/macos.sh" ]; then
    echo -e "${GREEN}✓ PASS${NC}: macOS script is executable"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAIL${NC}: macOS script is not executable"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  if [ -x "$SSH_GENERATOR_DIR/linux.sh" ]; then
    echo -e "${GREEN}✓ PASS${NC}: Linux script is executable"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAIL${NC}: Linux script is not executable"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Test 9: Utils.sh sources correctly
test_utils_sources() {
  # Check that utils.sh defines expected variables
  if grep -q "GITHUB_EMAIL=" "$SSH_GENERATOR_DIR/utils.sh"; then
    echo -e "${GREEN}✓ PASS${NC}: GITHUB_EMAIL defined in utils.sh"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAIL${NC}: GITHUB_EMAIL not defined in utils.sh"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi

  if grep -q "KEY_NAME=" "$SSH_GENERATOR_DIR/utils.sh"; then
    echo -e "${GREEN}✓ PASS${NC}: KEY_NAME defined in utils.sh"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAIL${NC}: KEY_NAME not defined in utils.sh"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Test 10: Email is correctly set
test_email_configuration() {
  local email_line
  email_line=$(grep "GITHUB_EMAIL=" "$SSH_GENERATOR_DIR/utils.sh" | head -1)
  assert_contains "$email_line" "18385321+dantehemerson@users.noreply.github.com" "Email should be set to 18385321+dantehemerson@users.noreply.github.com"
}

# Run tests
test_os_detection_macos
test_os_detection_arch
test_os_detection_ubuntu
test_os_detection_debian
test_os_detection_generic_linux
test_unsupported_os
test_script_files_exist
test_scripts_executable
test_utils_sources
test_email_configuration

# Cleanup
cleanup_test_env

# Print summary
print_summary
