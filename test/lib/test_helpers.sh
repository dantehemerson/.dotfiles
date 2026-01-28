#!/bin/bash

# Test Helpers for Dotfiles Post-Installation Tests
# This file contains helper functions and assertions for testing

# Source the main utils for platform detection
source ~/.dotfiles/utils/utils.sh





# Assert that a command exists
assert_command_exists() {
    local cmd="$1"
    
    command -v "$cmd" >/dev/null 2>&1
}

# Assert that a file exists and is a symlink
assert_file_is_symlink() {
    local file_path="$1"
    
    [ -L "$file_path" ]
}

# Assert that a symlink points to a specific target
assert_symlink_points_to() {
    local symlink_path="$1"
    local expected_target="$2"
    
    [ -L "$symlink_path" ] && [ "$(readlink "$symlink_path")" = "$expected_target" ]
}

# Assert that a file exists (not necessarily a symlink)
assert_file_exists() {
    local file_path="$1"
    
    [ -e "$file_path" ]
}

# Assert that a directory exists
assert_directory_exists() {
    local dir_path="$1"
    
    [ -d "$dir_path" ]
}

# Run a command as a specific user (for CI)
run_as_user() {
    local user="$1"
    local command="$2"
    
    if [ -n "$user" ]; then
        su - "$user" -c "bash -lc \"$command\""
    else
        bash -lc "$command"
    fi
}

# Check if a command exists as a specific user
command_exists_as_user() {
    local user="$1"
    local cmd="$2"
    
    if [ -n "$user" ]; then
        su - "$user" -c "bash -lc \"command -v $cmd\"" >/dev/null 2>&1
    else
        bash -lc "command -v $cmd" >/dev/null 2>&1
    fi
}



