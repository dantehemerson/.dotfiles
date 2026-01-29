#!/bin/sh

# Test runner for all utils tests
# Usage: ./run_all_tests.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
TEST_DIR="$(dirname "$0")"

# List of test files to run
TEST_FILES="
test_system_detection.sh
test_condition_parsing.sh
test_condition_evaluation.sh
test_load_packages.sh
"

# Overall test results
OVERALL_TOTAL=0
OVERALL_PASSED=0
OVERALL_FAILED=0

echo "${BLUE}=== Running Utils Tests ===${NC}"
echo ""

# Run each test file
for test_file in $TEST_FILES; do
    test_path="$TEST_DIR/$test_file"
    
    if [ -f "$test_path" ]; then
        echo "${YELLOW}Running: $test_file${NC}"
        echo "----------------------------------------"
        
        # Make the test file executable and run it
        chmod +x "$test_path"
        "$test_path"
        test_result=$?
        
        echo ""
        
        if [ $test_result -eq 0 ]; then
            echo "${GREEN}✓ $test_file PASSED${NC}"
        else
            echo "${RED}✗ $test_file FAILED${NC}"
            OVERALL_FAILED=$((OVERALL_FAILED + 1))
        fi
        echo "========================================"
        echo ""
    else
        echo "${RED}Test file not found: $test_path${NC}"
        echo ""
        OVERALL_FAILED=$((OVERALL_FAILED + 1))
    fi
done

echo "${BLUE}=== Overall Test Results ===${NC}"
echo ""

if [ $OVERALL_FAILED -eq 0 ]; then
    echo "${GREEN}🎉 All tests passed!${NC}"
    echo ""
    echo "The load_packages function and related utilities are working correctly."
    exit 0
else
    echo "${RED}❌ Some tests failed!${NC}"
    echo ""
    echo "Please check the test output above for details."
    exit 1
fi