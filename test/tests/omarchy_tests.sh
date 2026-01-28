#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

assert_command_exists "hyprland"
assert_command_exists "hyprctl"

assert_file_is_symlink "$HOME/.config/hypr/input.conf"
assert_file_is_symlink "$HOME/.config/hypr/bindings.conf"

if [ -L "$HOME/.bashrc" ]; then
    bashrc_target=$(readlink "$HOME/.bashrc")
    [[ "$bashrc_target" == *"omarchy"* ]]
else
    false
fi

assert_directory_exists "$HOME/.config/hypr"