#!/bin/bash

# Unit tests for utils.sh

set -e

# Source the test framework
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_common.sh"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}=== Testing utils.sh functions ========${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Setup test environment
setup_test_env

# Mock SSH_DIR and KEY_PATH for testing
SSH_DIR="$TEST_SSH_DIR/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519_gh"

# Test 1: check_existing_key - key does not exist
test_check_existing_key_not_exists() {
    assert_file_not_exists "$KEY_PATH" "Key file should not exist initially"
}

# Test 2: check_existing_key - key exists
test_check_existing_key_exists() {
    touch "$KEY_PATH"
    assert_file_exists "$KEY_PATH" "Key file should exist after touch"
    rm "$KEY_PATH"
}

# Test 3: Generate key - verify key file creation
test_generate_key_creates_files() {
    # Source utils with modified paths
    GITHUB_EMAIL="dantehemerson@gmail.com"
    
    # Create a mock ssh-keygen that creates files
    mkdir -p "$TEST_SSH_DIR/bin"
    cat > "$TEST_SSH_DIR/bin/ssh-keygen" << 'EOF'
#!/bin/bash
# Mock ssh-keygen
while [[ $# -gt 0 ]]; do
    case $1 in
        -f)
            KEYFILE="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Create mock key files
echo "-----BEGIN OPENSSH PRIVATE KEY-----" > "$KEYFILE"
echo "MOCK_KEY_DATA" >> "$KEYFILE"
echo "-----END OPENSSH PRIVATE KEY-----" >> "$KEYFILE"
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDemo mock_key dantehemerson@gmail.com" > "${KEYFILE}.pub"
EOF
    chmod +x "$TEST_SSH_DIR/bin/ssh-keygen"
    
    # Add to PATH
    export PATH="$TEST_SSH_DIR/bin:$PATH"
    
    # Generate key
    mkdir -p "$SSH_DIR"
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH" -N ""
    
    # Verify files created
    assert_file_exists "$KEY_PATH" "Private key file should be created"
    assert_file_exists "${KEY_PATH}.pub" "Public key file should be created"
}

# Test 4: Verify email in public key
test_public_key_contains_email() {
    local pub_key_content
    pub_key_content=$(cat "${KEY_PATH}.pub")
    assert_contains "$pub_key_content" "dantehemerson@gmail.com" "Public key should contain the email"
}

# Test 5: Verify key algorithm in public key
test_public_key_contains_algorithm() {
    local pub_key_content
    pub_key_content=$(cat "${KEY_PATH}.pub")
    assert_contains "$pub_key_content" "ssh-ed25519" "Public key should contain ed25519 algorithm"
}

# Test 6: SSH directory permissions
test_ssh_directory_permissions() {
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    local perms
    perms=$(stat -f "%Lp" "$SSH_DIR" 2>/dev/null || stat -c "%a" "$SSH_DIR" 2>/dev/null)
    assert_equals "700" "$perms" "SSH directory should have 700 permissions"
}

# Run tests
test_check_existing_key_not_exists
test_check_existing_key_exists
test_generate_key_creates_files
test_public_key_contains_email
test_public_key_contains_algorithm
test_ssh_directory_permissions

# Cleanup
cleanup_test_env

# Print summary
print_summary
