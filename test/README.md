# Dotfiles Post-Installation Test Suite

This test suite verifies that all commands are available and all files are properly symlinked after dotfiles installation.

## Structure

```
test/
├── post_install.test.sh          # Main test script
├── lib/
│   ├── test_helpers.sh           # Helper functions and assertions
├── tests/
│   ├── common_tests.sh           # Tests for all platforms
│   ├── macos_tests.sh            # macOS-specific tests
│   ├── arch_tests.sh             # Arch Linux-specific tests
│   ├── ubuntu_tests.sh           # Ubuntu-specific tests
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
```

Note: Individual test scripts will show their own summary when run directly.

### Test persistent Herdr LazyGit popups
```bash
mise exec -- python3 test/herdr_lazygit_test.py
mise exec -- python3 test/herdr_lazygit_push_test.py
```
Uses an isolated tmux server and a fake LazyGit to test detach/reopen,
worktree isolation, and work continuing after dismissal. The push tests use
temporary local bare repositories to verify real pushes survive cancellation
of their caller and pressing `q` in real LazyGit through the full tmux popup
launcher, and preserve output, exit status, and failure reporting.
No hosted remote is contacted.

## What Gets Tested

### Common Tests (All Platforms)
- **Commands**: git, wget, curl, bash, zsh, btop, htop, tree, jq, yq, neovim, ripgrep, bat, lazygit
- **Symlinks**: .zshrc, .zimrc, .bashrc, .bash_profile, starship.toml, .gitconfig, .vimrc, .tmux.conf, zed settings, neovim config
- **Directories**: .config, .config/nvim, .config/zed

### Platform-Specific Tests

#### macOS
- **Commands**: starship, unzip, brew, mas, gh, ghostty
- **Symlinks**: .inputrc, ghostty config
- **Homebrew**: Installation, health, update capability
- **Shell**: Homebrew bash in /etc/shells
- **Directories**: Pictures/Screenshots, .config/ghostty

#### Arch Linux
- **Commands**: pacman, fd, yay
- **Package Manager**: pacman and yay functionality
- **Directories**: /etc/pacman.d, /var/cache/pacman

#### Ubuntu
- **Commands**: apt, fd (or fdfind), superfile (or spf)
- **Package Manager**: apt functionality
- **Directories**: /etc/apt, /var/cache/apt

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
