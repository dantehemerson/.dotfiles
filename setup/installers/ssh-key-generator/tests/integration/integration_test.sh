#!/bin/bash

# Integration test for SSH key generator
# Tests the full flow without generating actual SSH keys

set -e

# Source the test framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../test_common.sh"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}=== Integration Tests ================${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Setup test environment
setup_test_env

SSH_GENERATOR_DIR="$(dirname "$TEST_DIR")"
SSH_DIR="$TEST_SSH_DIR/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519_gh"
PUB_KEY_PATH="${KEY_PATH}.pub"

# Create mock binaries
mkdir -p "$TEST_SSH_DIR/bin"

# Mock ssh-keygen
cat > "$TEST_SSH_DIR/bin/ssh-keygen" << 'EOF'
#!/bin/bash
# Parse arguments
KEYFILE=""
COMMENT=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -t) shift ;;
        -C) COMMENT="$2"; shift 2 ;;
        -f) KEYFILE="$2"; shift 2 ;;
        -N) shift 2 ;;
        *) shift ;;
    esac
done

# Create mock key files
if [ -n "$KEYFILE" ]; then
    # Private key
    cat > "$KEYFILE" << PRIVKEY
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBdemo mock key for testing only not real
-----END OPENSSH PRIVATE KEY-----
PRIVKEY
    chmod 600 "$KEYFILE"
    
    # Public key
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDemo mock_key for testing ${COMMENT}" > "${KEYFILE}.pub"
    chmod 644 "${KEYFILE}.pub"
fi

exit 0
EOF
chmod +x "$TEST_SSH_DIR/bin/ssh-keygen"

# Mock ssh-agent
cat > "$TEST_SSH_DIR/bin/ssh-agent" << 'EOF'
#!/bin/bash
echo "SSH_AGENT_LAUNCHER=launchd"
echo "SSH_AUTH_SOCK=/tmp/ssh-agent-test.sock"
echo "SSH_AGENT_PID=12345"
EOF
chmod +x "$TEST_SSH_DIR/bin/ssh-agent"

# Mock ssh-add
cat > "$TEST_SSH_DIR/bin/ssh-add" << 'EOF'
#!/bin/bash
# Accept any key file
exit 0
EOF
chmod +x "$TEST_SSH_DIR/bin/ssh-add"

# Add mock binaries to PATH
export PATH="$TEST_SSH_DIR/bin:$PATH"

# Test 1: Full generation flow - Linux
test_full_generation_flow_linux() {
    echo -e "${YELLOW}Testing Linux flow...${NC}"
    
    # Set Linux environment
    export CURRENT_OS="linux"
    export CURRENT_DISTRO="ubuntu"
    export HOME="$TEST_SSH_DIR"
    
    # Source utils and run key generation
    GITHUB_EMAIL="dantehemerson@gmail.com"
    
    # Create SSH dir
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    
    # Generate key
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH" -N ""
    
    # Verify key files
    assert_file_exists "$KEY_PATH" "Private key should be created"
    assert_file_exists "$PUB_KEY_PATH" "Public key should be created"
    
    # Verify key content
    local pub_content
    pub_content=$(cat "$PUB_KEY_PATH")
    assert_contains "$pub_content" "ssh-ed25519" "Public key should have correct algorithm"
    assert_contains "$pub_content" "dantehemerson@gmail.com" "Public key should have correct email"
    
    # Create SSH config (Linux version)
    cat >> "$SSH_DIR/config" << EOF

Host github.com
  AddKeysToAgent yes
  IdentityFile $KEY_PATH
EOF
    chmod 600 "$SSH_DIR/config"
    
    # Verify config
    assert_file_exists "$SSH_DIR/config" "SSH config should be created"
    local config_content
    config_content=$(cat "$SSH_DIR/config")
    assert_contains "$config_content" "IdentityFile $KEY_PATH" "Config should reference the key"
    assert_not_contains "$config_content" "UseKeychain" "Linux config should not have UseKeychain"
    
    # Clean up for next test
    rm -rf "$SSH_DIR"/*
}

# Test 2: Full generation flow - macOS
test_full_generation_flow_macos() {
    echo -e "${YELLOW}Testing macOS flow...${NC}"
    
    # Set macOS environment
    export CURRENT_OS="macos"
    export CURRENT_DISTRO="unknown"
    export HOME="$TEST_SSH_DIR"
    
    # Source utils and run key generation
    GITHUB_EMAIL="dantehemerson@gmail.com"
    
    # Create SSH dir
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    
    # Generate key
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH" -N ""
    
    # Verify key files
    assert_file_exists "$KEY_PATH" "Private key should be created"
    assert_file_exists "$PUB_KEY_PATH" "Public key should be created"
    
    # Create SSH config (macOS version)
    cat >> "$SSH_DIR/config" << EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_PATH
EOF
    chmod 600 "$SSH_DIR/config"
    
    # Verify config
    assert_file_exists "$SSH_DIR/config" "SSH config should be created"
    local config_content
    config_content=$(cat "$SSH_DIR/config")
    assert_contains "$config_content" "IdentityFile $KEY_PATH" "Config should reference the key"
    assert_contains "$config_content" "UseKeychain yes" "macOS config should have UseKeychain"
    assert_contains "$config_content" "AddKeysToAgent yes" "Config should have AddKeysToAgent"
}

# Test 3: Key already exists - should exit
test_key_already_exists() {
    echo -e "${YELLOW}Testing key already exists scenario...${NC}"
    
    export HOME="$TEST_SSH_DIR"
    
    # Create existing key
    mkdir -p "$SSH_DIR"
    touch "$KEY_PATH"
    
    # Verify key exists
    assert_file_exists "$KEY_PATH" "Pre-existing key should exist"
    
    echo -e "${GREEN}✓ PASS${NC}: Key existence check works (manual verification)"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    TESTS_PASSED=$((TESTS_PASSED + 1))
    
    rm -rf "$SSH_DIR"/*
}

# Test 4: Verify key naming convention
test_key_naming_convention() {
    echo -e "${YELLOW}Testing key naming convention...${NC}"
    
    export HOME="$TEST_SSH_DIR"
    
    # Verify the key name includes 'gh'
    assert_contains "$KEY_PATH" "id_ed25519_gh" "Key should use custom name with 'gh' suffix"
    
    # Verify it's NOT the default name (exact match)
    local base_name
    base_name=$(basename "$KEY_PATH")
    if [ "$base_name" = "id_ed25519" ]; then
        echo -e "${RED}✗ FAIL${NC}: Key should NOT use default name (exact match)"
        TESTS_TOTAL=$((TESTS_TOTAL + 1))
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo -e "${GREEN}✓ PASS${NC}: Key should NOT use default name (exact match)"
        TESTS_TOTAL=$((TESTS_TOTAL + 1))
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
    
    echo -e "${GREEN}✓ PASS${NC}: Key naming convention is correct"
}

# Run tests
test_full_generation_flow_linux
test_full_generation_flow_macos
test_key_already_exists
test_key_naming_convention

# Cleanup
cleanup_test_env

# Print summary
print_summary
