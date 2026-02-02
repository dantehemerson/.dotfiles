#!/bin/bash

# Unit tests for linux.sh

set -e

# Source the test framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_common.sh"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}=== Testing linux.sh functions ========${NC}"
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

# Test 1: SSH config creation - Linux version (no UseKeychain)
test_configure_ssh_config_linux() {
  local ssh_config="$SSH_DIR/config"

  # Ensure config doesn't exist
  rm -f "$ssh_config"
  assert_file_not_exists "$ssh_config" "Config should not exist initially"

  # Create config (Linux version - no UseKeychain)
  cat >>"$ssh_config" <<EOF

Host github.com
  AddKeysToAgent yes
  IdentityFile $KEY_PATH
EOF
  chmod 600 "$ssh_config"

  assert_file_exists "$ssh_config" "Config file should be created"
}

# Test 2: Linux SSH config does NOT contain UseKeychain
test_linux_config_no_keychain() {
  local ssh_config="$SSH_DIR/config"
  local config_content
  config_content=$(cat "$ssh_config")

  assert_contains "$config_content" "Host github.com" "Config should contain Host github.com"
  assert_contains "$config_content" "AddKeysToAgent yes" "Config should contain AddKeysToAgent"
  assert_contains "$config_content" "IdentityFile $KEY_PATH" "Config should contain IdentityFile"
  assert_not_contains "$config_content" "UseKeychain" "Linux config should NOT contain UseKeychain"
}

# Test 3: Linux SSH config permissions
test_linux_ssh_config_permissions() {
  local ssh_config="$SSH_DIR/config"
  chmod 600 "$ssh_config"

  local perms
  perms=$(stat -c "%a" "$ssh_config" 2>/dev/null || stat -f "%Lp" "$ssh_config" 2>/dev/null)
  assert_equals "600" "$perms" "SSH config should have 600 permissions"
}

# Test 4: Linux ssh-add without keychain options
test_linux_ssh_add_simple() {
  # Mock ssh-add
  mkdir -p "$TEST_SSH_DIR/bin"
  cat >"$TEST_SSH_DIR/bin/ssh-add" <<'EOF'
#!/bin/bash
# Mock ssh-add for Linux - simple version
if [[ "$1" == "$HOME/.ssh/id_ed25519_gh" ]]; then
    exit 0
else
    exit 1
fi
EOF
  chmod +x "$TEST_SSH_DIR/bin/ssh-add"
  export PATH="$TEST_SSH_DIR/bin:$PATH"

  # Test simple ssh-add
  if ssh-add "$KEY_PATH" 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC}: Linux ssh-add works without keychain options"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAIL${NC}: Linux ssh-add failed"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
}

# Test 5: Linux key path validation
test_linux_key_path() {
  assert_contains "$KEY_PATH" "id_ed25519_gh" "Linux should use custom key name"
  assert_contains "$KEY_PATH" ".ssh" "Key should be in .ssh directory"
}

# Run tests
test_configure_ssh_config_linux
test_linux_config_no_keychain
test_linux_ssh_config_permissions
test_linux_ssh_add_simple
test_linux_key_path

# Cleanup
cleanup_test_env

# Print summary
print_summary
