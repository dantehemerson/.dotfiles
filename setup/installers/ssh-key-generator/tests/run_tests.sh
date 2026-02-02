#!/bin/bash

# Test runner for SSH key generator
# Runs all unit and integration tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Track overall results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to run a test file and capture results
run_test_file() {
    local test_file="$1"
    local test_name="$2"
    
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Running: $test_name${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    if [ -f "$test_file" ]; then
        # Run the test and capture exit code
        if bash "$test_file"; then
            echo ""
            echo -e "${GREEN}✓ $test_name completed${NC}"
        else
            echo ""
            echo -e "${RED}✗ $test_name had failures${NC}"
        fi
        echo ""
    else
        echo -e "${RED}Test file not found: $test_file${NC}"
        return 1
    fi
}

# Main test runner
main() {
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${BLUE}===== SSH Key Generator Test Suite ============${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo ""
    
    local failed=0
    
    # Run unit tests
    echo -e "${YELLOW}Running Unit Tests...${NC}"
    echo ""
    
    run_test_file "$SCRIPT_DIR/test_utils.sh" "Utils Tests"
    run_test_file "$SCRIPT_DIR/test_macos.sh" "macOS Tests"
    run_test_file "$SCRIPT_DIR/test_linux.sh" "Linux Tests"
    run_test_file "$SCRIPT_DIR/test_ssh_key_generator.sh" "Main Script Tests"
    
    # Run integration tests
    echo -e "${YELLOW}Running Integration Tests...${NC}"
    echo ""
    
    run_test_file "$SCRIPT_DIR/integration/integration_test.sh" "Integration Tests"
    
    # Final summary
    echo ""
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${BLUE}============== Test Suite Complete ============${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo ""
    
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}✅ All test suites completed!${NC}"
        return 0
    else
        echo -e "${RED}❌ Some test suites had failures${NC}"
        return 1
    fi
}

# Run main
main "$@"
