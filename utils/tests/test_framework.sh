#!/bin/sh

# Simple test framework for shell functions
# Usage: ./test_framework.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Assert functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [ "$expected" = "$actual" ]; then
        echo "${GREEN}✓ PASS${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo "${RED}✗ FAIL${NC}: $test_name"
        echo "  Expected: '$expected'"
        echo "  Actual:   '$actual'"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    case "$haystack" in
        *"$needle"*)
            echo "${GREEN}✓ PASS${NC}: $test_name"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            return 0
            ;;
        *)
            echo "${RED}✗ FAIL${NC}: $test_name"
            echo "  String '$haystack' does not contain '$needle'"
            TESTS_FAILED=$((TESTS_FAILED + 1))
            return 1
            ;;
    esac
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    case "$haystack" in
        *"$needle"*)
            echo "${RED}✗ FAIL${NC}: $test_name"
            echo "  String '$haystack' contains '$needle' (should not)"
            TESTS_FAILED=$((TESTS_FAILED + 1))
            return 1
            ;;
        *)
            echo "${GREEN}✓ PASS${NC}: $test_name"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            return 0
            ;;
    esac
}

assert_true() {
    local condition="$1"
    local test_name="$2"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [ "$condition" = "0" ] || [ "$condition" = "true" ]; then
        echo "${GREEN}✓ PASS${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo "${RED}✗ FAIL${NC}: $test_name"
        echo "  Expected true, got: $condition"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_false() {
    local condition="$1"
    local test_name="$2"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [ "$condition" != "0" ] && [ "$condition" != "true" ]; then
        echo "${GREEN}✓ PASS${NC}: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo "${RED}✗ FAIL${NC}: $test_name"
        echo "  Expected false, got: $condition"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Print test summary
print_summary() {
    echo ""
    echo "${YELLOW}=== Test Summary ===${NC}"
    echo "Total:  $TESTS_TOTAL"
    echo "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo "Failed: ${RED}$TESTS_FAILED${NC}"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo "${GREEN}All tests passed!${NC}"
        return 0
    else
        echo "${RED}Some tests failed!${NC}"
        return 1
    fi
}

# Reset test counters
reset_tests() {
    TESTS_TOTAL=0
    TESTS_PASSED=0
    TESTS_FAILED=0
}

# Helper to create temporary test files
create_test_file() {
    local filename="$1"
    local content="$2"
    
    echo "$content" > "$filename"
}

# Helper to cleanup temporary files
cleanup_test_file() {
    local filename="$1"
    
    if [ -f "$filename" ]; then
        rm "$filename"
    fi
}