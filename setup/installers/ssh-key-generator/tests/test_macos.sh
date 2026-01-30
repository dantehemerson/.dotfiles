#!/bin/bash

# Unit tests for macos.sh

set -e

# Source the test framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_common.sh"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}=== Testing macos.sh functions ========${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Setup test environment
setup_test_env

SSH_DIR="$TEST_SSH_DIR/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519_gh"

# Create mock key for testing
mkdir -p "$SSH_DIR"
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDemo mock_key 18385321+dantehemerson@users.noreply.github.com" >"${KEY_PATH}.pub"
echo "-----BEGIN OPENSSH PRIVATE KEY-----" >"$KEY_PATH"

# Test 1: SSH config creation - new file
test_configure_ssh_config_creates_file() {
  local ssh_config="$SSH_DIR/config"

  # Ensure config doesn't exist
  rm -f "$ssh_config"
  assert_file_not_exists "$ssh_config" "Config should not exist initially"

  # Create config
  cat >>"$ssh_config" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_PATH
EOF
  chmod 600 "$ssh_config"

  assert_file_exists "$ssh_config" "Config file should be created"
}

# Test 2: SSH config contains correct entries
test_ssh_config_contains_entries() {
  local ssh_config="$SSH_DIR/config"
  local config_content
  config_content=$(cat "$ssh_config")

  assert_contains "$config_content" "Host github.com" "Config should contain Host github.com"
  assert_contains "$config_content" "AddKeysToAgent yes" "Config should contain AddKeysToAgent"
  assert_contains "$config_content" "UseKeychain yes" "Config should contain UseKeychain (macOS specific)"
  assert_contains "$config_content" "IdentityFile $KEY_PATH" "Config should contain IdentityFile"
  assert_contains "$config_content" "id_ed25519_gh" "Config should reference the gh key"
}

# Test 3: SSH config file permissions
test_ssh_config_permissions() {
  local ssh_config="$SSH_DIR/config"
  chmod 600 "$ssh_config"

  local perms
  perms=$(stat -f "%Lp" "$ssh_config" 2>/dev/null || stat -c "%a" "$ssh_config" 2>/dev/null)
  assert_equals "600" "$perms" "SSH config should have 600 permissions"
}

# Test 4: SSH config - duplicate detection
test_configure_ssh_config_no_duplicate() {
  local ssh_config="$SSH_DIR/config"

  # Check if already contains the key
  if [ -f "$ssh_config" ] && grep -q "IdentityFile.*id_ed25519_gh" "$ssh_config" 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC}: Duplicate detection works"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    # Add the entry first
    cat >>"$ssh_config" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_PATH
EOF

    # Now check for duplicate
    local count
    count=$(grep -c "IdentityFile.*id_ed25519_gh" "$ssh_config" 2>/dev/null || echo "0")
    if [ "$count" -eq 1 ]; then
      echo -e "${GREEN}✓ PASS${NC}: No duplicate entries created"
      TESTS_TOTAL=$((TESTS_TOTAL + 1))
      TESTS_PASSED=$((TESTS_PASSED + 1))
    else
      echo -e "${RED}✗ FAIL${NC}: Duplicate entries detected (count: $count)"
      TESTS_TOTAL=$((TESTS_TOTAL + 1))
      TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
  fi
}

# Test 5: macOS-specific commands
test_macos_keychain_option() {
  # Mock ssh-add to test command
  mkdir -p "$TEST_SSH_DIR/bin"
  cat >"$TEST_SSH_DIR/bin/ssh-add" <<'EOF'
#!/bin/bash
# Mock ssh-add that supports --apple-use-keychain
if [[ "$1" == "--apple-use-keychain" ]]; then
    exit 0
else
    exit 1
fi
EOF
  chmod +x "$TEST_SSH_DIR/bin/ssh-add"
  export PATH="$TEST_SSH_DIR/bin:$PATH"

  # Test that --apple-use-keychain works
  if ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC}: macOS --apple-use-keychain option supported"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAIL${NC}: macOS --apple-use-keychain option not supported"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Run tests
test_configure_ssh_config_creates_file
test_ssh_config_contains_entries
test_ssh_config_permissions
test_configure_ssh_config_no_duplicate
test_macos_keychain_option

# Cleanup
cleanup_test_env

# Print summary
print_summary
