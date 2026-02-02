# SSH Key Generator Test Suite

Comprehensive test suite for the SSH key generator scripts.

## Structure

```
tests/
├── test_common.sh                 # Shared test framework and utilities
├── test_utils.sh                  # Unit tests for utils.sh functions
├── test_macos.sh                  # Unit tests for macOS-specific functions
├── test_linux.sh                  # Unit tests for Linux-specific functions
├── test_ssh_key_generator.sh      # Unit tests for main entry point
├── integration/
│   └── integration_test.sh        # End-to-end integration tests
└── run_tests.sh                   # Test runner - executes all tests
```

## Usage

### Run all tests
```bash
./tests/run_tests.sh
```

### Run individual test files
```bash
# Test shared utilities
./tests/test_utils.sh

# Test macOS implementation
./tests/test_macos.sh

# Test Linux implementation
./tests/test_linux.sh

# Test main entry point
./tests/test_ssh_key_generator.sh

# Run integration tests
./tests/integration/integration_test.sh
```

## What Gets Tested

### Unit Tests

#### test_utils.sh
- **Key existence detection**: Verifies logic for checking if key already exists
- **Key generation**: Tests that key files are created correctly
- **Email in public key**: Verifies email is included in public key comment
- **Key algorithm**: Confirms Ed25519 algorithm is used
- **SSH directory permissions**: Ensures .ssh directory has correct 700 permissions

#### test_macos.sh
- **SSH config creation**: Verifies config file is created
- **macOS-specific entries**: Confirms `UseKeychain yes` is present
- **Config permissions**: Ensures config has 600 permissions
- **Duplicate detection**: Verifies no duplicate entries in config
- **Keychain support**: Tests `--apple-use-keychain` option support

#### test_linux.sh
- **SSH config creation**: Verifies config file is created
- **No keychain entries**: Confirms `UseKeychain` is NOT present (Linux-specific)
- **Config permissions**: Ensures config has 600 permissions
- **Simple ssh-add**: Tests ssh-add without keychain options
- **Key path validation**: Verifies custom key name is used

#### test_ssh_key_generator.sh
- **OS detection**: macOS, Arch, Ubuntu, Debian, generic Linux
- **Unsupported OS handling**: Verifies error on unsupported OS
- **Script file existence**: Confirms all required files exist
- **Executable permissions**: Verifies scripts are executable
- **Configuration**: Tests email and key name configuration

### Integration Tests

#### integration_test.sh
- **Full Linux flow**: End-to-end test of Linux implementation
- **Full macOS flow**: End-to-end test of macOS implementation
- **Key existence handling**: Tests behavior when key already exists
- **Key naming convention**: Verifies `id_ed25519_gh` naming
- **Mock SSH tools**: Uses mock ssh-keygen, ssh-agent, and ssh-add to avoid side effects

## Test Framework

The tests use a simple custom framework defined in `test_common.sh`:

### Assertions
- `assert_equals expected actual "test name"` - Compare values
- `assert_file_exists path "test name"` - Verify file exists
- `assert_file_not_exists path "test name"` - Verify file doesn't exist
- `assert_contains haystack needle "test name"` - Check string contains substring
- `assert_not_contains haystack needle "test name"` - Check string doesn't contain substring
- `assert_true condition "test name"` - Verify condition is true (exit code 0)
- `assert_false condition "test name"` - Verify condition is false (non-zero exit)

### Test Environment
- `setup_test_env` - Creates temporary test directory
- `cleanup_test_env` - Removes temporary test directory
- All tests run in isolated temporary directories to avoid affecting real SSH keys

## Mocking Strategy

Tests use mock implementations of SSH tools to avoid:
- Generating real SSH keys
- Modifying actual `~/.ssh` directory
- Starting real ssh-agent processes
- Modifying actual SSH config

Mock binaries are created in temporary directories and added to PATH during tests.

## Adding New Tests

To add a new test:

1. Add test function to appropriate test file
2. Use assertions from test_common.sh
3. Call `setup_test_env` at start and `cleanup_test_env` at end
4. Add test function call at bottom of file
5. Run tests to verify

Example:
```bash
test_new_feature() {
    setup_test_env
    
    # Your test code here
    assert_file_exists "$EXPECTED_FILE" "File should be created"
    
    cleanup_test_env
}

# Run the test
test_new_feature
print_summary
```

## CI Integration

Tests can be integrated into CI pipelines:

```yaml
- name: Run SSH Key Generator Tests
  run: |
    cd setup/installers/ssh-key-generator
    ./tests/run_tests.sh
```

All tests exit with code 0 on success, non-zero on failure.
