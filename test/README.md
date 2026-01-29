# Dotfiles Post-Installation Test Suite

This test suite verifies that all commands are available and all files are properly symlinked after dotfiles installation.

## Structure

```
test/
├── post_install.test.sh          # Main test script
├── lib/
│   ├── test_helpers.sh           # Helper functions and assertions
│   └── platform_detection.sh     # Platform detection utilities
├── tests/
│   ├── common_tests.sh           # Tests for all platforms
│   ├── macos_tests.sh            # macOS-specific tests
│   ├── arch_tests.sh             # Arch Linux-specific tests
│   ├── ubuntu_tests.sh           # Ubuntu-specific tests
│   ├── debian_tests.sh           # Debian-specific tests
│   └── omarchy_tests.sh          # Omarchy-specific tests (Hyprland)
└── README.md                     # This file
```

## Usage

### Run all tests
```bash
./test/post_install.test.sh
```

### Run as a specific user (for CI)
```bash
./test/post_install.test.sh --run-as ci
```

### Run individual test files
```bash
# Run common tests only
./test/tests/common_tests.sh

# Run platform-specific tests
./test/tests/macos_tests.sh
./test/tests/arch_tests.sh
./test/tests/ubuntu_tests.sh
./test/tests/debian_tests.sh
./test/tests/omarchy_tests.sh
```

Note: Individual test scripts will show their own summary when run directly.

## What Gets Tested

### Common Tests (All Platforms)
- **Commands**: git, wget, curl, bash, zsh, btop, htop, tree, jq, yq, neovim, ripgrep, bat, lazygit
- **Symlinks**: .zshrc, .zimrc, .bashrc, .bash_profile, starship.toml, .gitconfig, .vimrc, .tmux.conf, zed settings, neovim config
- **Directories**: .config, .config/nvim, .config/zed

### Platform-Specific Tests

#### macOS
- **Commands**: starship, unzip, brew, mas, gh, ghostty, fnm
- **Symlinks**: .inputrc, ghostty config
- **Homebrew**: Installation, health, update capability
- **Shell**: Homebrew bash in /etc/shells
- **Directories**: Pictures/Screenshots, .config/ghostty

#### Arch Linux
- **Commands**: pacman, fd, yay
- **Package Manager**: pacman and yay functionality
- **Directories**: /etc/pacman.d, /var/cache/pacman

#### Ubuntu/Debian
- **Commands**: apt, rust-fd-find, superfile
- **Package Manager**: apt functionality
- **Directories**: /etc/apt, /var/cache/apt

#### Omarchy (Hyprland)
- **Commands**: hyprland, hyprctl
- **Symlinks**: Hyprland config files, omarchy .bashrc
- **Directories**: .config/hypr

## Integration with GitHub Actions

This test suite is designed to replace the inline script in `.github/actions/dotfiles-test/action.yml`. It maintains compatibility with the `run_as` input parameter used in CI workflows.

## Test Output

The test suite provides:
- Color-coded output (green for pass, red for fail)
- Test summary with pass/fail counts
- Clear error messages for failed tests

## Contributing

When adding new tools or configurations to your dotfiles, make sure to:
1. Add appropriate tests to the relevant test file
2. Update the common tests for cross-platform tools
3. Update platform-specific tests for platform-specific tools
4. Test the test suite itself to ensure it works correctly