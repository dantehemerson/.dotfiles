# Utils Tests

This directory contains comprehensive tests for the `utils.sh` conditional package loading functionality.

## Test Structure

```
utils/tests/
├── test_framework.sh          # Simple test framework for shell scripts
├── test_system_detection.sh   # Tests for OS, arch, PM, and distro detection
├── test_condition_parsing.sh  # Tests for parsing package condition syntax
├── test_condition_evaluation.sh # Tests for condition evaluation logic
├── test_load_packages.sh      # Tests for the main load_packages function
├── run_all_tests.sh           # Test runner that executes all tests
└── README.md                  # This file
```

## Running Tests

### Run All Tests
```bash
cd utils/tests
./run_all_tests.sh
```

### Run Individual Test Files
```bash
cd utils/tests
./test_system_detection.sh
./test_condition_parsing.sh
./test_condition_evaluation.sh
./test_load_packages.sh
```

## Test Coverage

### System Detection Tests (11 tests)
- OS detection: `linux`, `macos`, `windows`
- Architecture detection: `x86_64`, `arm64`
- Package manager detection: `brew`, `apt`, `pacman`
- Distribution detection: `arch`, `fedora`, `ubuntu`

### Condition Parsing Tests (9 tests)
- Package names without conditions
- Single conditions: `git[os.linux]`
- Multiple conditions: `docker[os.linux,pm.apt]`
- Exclusion conditions: `wget[~pm.brew]`
- Complex conditions: `neovim[os.macos,arch.arm64]`
- Edge cases: empty names, nested brackets, etc.

### Condition Evaluation Tests (19 tests)
- Empty conditions (always install)
- Inclusive conditions: `os.linux`, `arch.x86_64`, `pm.apt`, `distro.fedora`
- Exclusive conditions: `~os.macos`, `~arch.arm64`, `~pm.brew`, `~distro.arch`
- Unknown conditions and edge cases

### Load Packages Tests (10 tests)
- Basic packages without conditions
- OS-specific packages
- Package manager exclusions
- Architecture conditions
- Distribution conditions
- Empty files and comment-only files
- Complex multi-condition scenarios
- Different system configurations

## Test Framework Features

The `test_framework.sh` provides:

- **Assertion Functions**: `assert_equals`, `assert_contains`, `assert_true`, `assert_false`
- **Colored Output**: Green for passes, red for failures, yellow for highlights
- **Test Summary**: Total, passed, and failed test counts
- **Helper Functions**: File creation/cleanup for temporary test files

## Example Test Output

```
=== Running Utils Tests ===

Running: test_system_detection.sh
----------------------------------------
Testing system detection functions...
✓ PASS: OS detection set to linux
✓ PASS: Architecture detection set to x86_64
✓ PASS: Package manager detection set to brew
✓ PASS: Distribution detection set to fedora

=== Test Summary ===
Total:  11
Passed: 11
Failed: 0
All tests passed!

✓ test_system_detection.sh PASSED
========================================

🎉 All tests passed!

The load_packages function and related utilities are working correctly.
```

## Total Test Coverage

- **49 individual tests** across all test files
- **100% pass rate** ✅
- Tests cover all major functionality and edge cases
- Compatible with `#!/bin/sh` (not bash-specific)

The test suite ensures that the conditional package loading system works correctly across different operating systems, architectures, package managers, and distributions.