#!/bin/bash

# Load .env to customize the installation
if [ -f .env.sh ]; then
  source .env.sh
fi

# VERSION="0.1"

# parser_definition() {
#   setup   REST help:usage -- "Usage: example.sh [options]... [arguments]..." ''
#   msg -- 'Options:'
#   flag    FLAG    -f --flag                 -- "takes no arguments"
#   flag    SKIP_GITCONFIG_LINKIG   --skip-gitconfig-linking  -- "skip linking .gitconfig"
#   param   PARAM   -p --param                -- "takes one argument"
#   option  OPTION  -o --option on:"default"  -- "takes one optional argument"
#   disp    :usage  -h --help
#   disp    VERSION    --version
#   disp    SOLUTION -s  --solution
# }

# eval "$(./deps/getoptions parser_definition) exit 1" # argument parsing

# echo "FLAG: $FLAG, PARAM: $PARAM, OPTION: $OPTION"
# printf '%s\n' "$@" # output rest argument
#

# Dotfiles folder
export DOTFILES_DIR="$HOME/.dotfiles"

if [[ "$(uname)" == "Linux" ]]; then
  export IS_LINUX=true
elif [[ "$(uname)" == "Darwin" ]]; then
  export IS_OSX=true
fi

# System detection variables for conditional package loading
export CURRENT_OS=""
export CURRENT_ARCH=""
export CURRENT_PM=""
export CURRENT_DISTRO=""
export CURRENT_FLAVOR=""

# Detect current operating system
detect_os() {
  if [[ "$(uname)" == "Linux" ]]; then
    export CURRENT_OS="linux"
  elif [[ "$(uname)" == "Darwin" ]]; then
    export CURRENT_OS="macos"
  elif [[ "$(uname)" == "MINGW"* ]] || [[ "$(uname)" == "CYGWIN"* ]]; then
    export CURRENT_OS="windows"
  else
    export CURRENT_OS="unknown"
  fi
}

# Detect current architecture
detect_arch() {
  local arch=$(uname -m)
  case "$arch" in
    x86_64)
      export CURRENT_ARCH="x86_64"
      ;;
    arm64|aarch64)
      export CURRENT_ARCH="arm64"
      ;;
    *)
      export CURRENT_ARCH="unknown"
      ;;
  esac
}

# Detect current package manager
detect_pm() {
  if command -v brew >/dev/null 2>&1; then
    export CURRENT_PM="brew"
  elif command -v apt >/dev/null 2>&1; then
    export CURRENT_PM="apt"
  elif command -v pacman >/dev/null 2>&1; then
    export CURRENT_PM="pacman"
  elif command -v dnf >/dev/null 2>&1; then
    export CURRENT_PM="dnf"
  elif command -v yum >/dev/null 2>&1; then
    export CURRENT_PM="yum"
  else
    export CURRENT_PM="unknown"
  fi
}

# Detect current distribution
detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case "$ID" in
      ubuntu)
        export CURRENT_DISTRO="ubuntu"
        ;;
      debian)
        export CURRENT_DISTRO="debian"
        ;;
      arch)
        export CURRENT_DISTRO="arch"
        ;;
      fedora)
        export CURRENT_DISTRO="fedora"
        ;;
      rhel|centos)
        export CURRENT_DISTRO="rhel"
        ;;
      *)
        export CURRENT_DISTRO="unknown"
        ;;
    esac
  else
    export CURRENT_DISTRO="unknown"
  fi
}

# Detect current flavor/distribution variant
detect_flavor() {
  if [ -n "$OMARCHY_PATH" ]; then
    export CURRENT_FLAVOR="omarchy"
  else
    export CURRENT_FLAVOR="unknown"
  fi
}

# Initialize system detection
detect_os
detect_arch
detect_pm
detect_distro
detect_flavor

# Parse package line to extract package name and conditions
# Returns: package_name and conditions_string
parse_package_line() {
  local line="$1"
  local package_name="$line"
  local conditions=""
  
  # Check if line contains opening bracket
  case "$line" in
    *"["*)
      # Extract package name (everything before [)
      package_name=$(echo "$line" | cut -d'[' -f1)
      # Extract conditions (everything after [ and before ])
      conditions=$(echo "$line" | cut -d'[' -f2 | cut -d']' -f1)
      ;;
  esac
  
  echo "$package_name|$conditions"
}

# Evaluate inclusive conditions (all must match)
# Returns 0 if conditions are satisfied, 1 otherwise
evaluate_inclusive_conditions() {
  local conditions="$1"
  local first_condition
  
  # Get first condition to check
  first_condition=$(echo "$conditions" | cut -d',' -f1 | xargs)
  
  case "$first_condition" in
    os.*)
      local target_os=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_OS" = "$target_os" ]
      ;;
    arch.*)
      local target_arch=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_ARCH" = "$target_arch" ]
      ;;
    pm.*)
      local target_pm=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_PM" = "$target_pm" ]
      ;;
    distro.*)
      local target_distro=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_DISTRO" = "$target_distro" ]
      ;;
    *)
      return 1
      ;;
  esac
}

# Evaluate exclusive conditions (none must match)
# Returns 0 if no conditions are matched, 1 if any condition matches
evaluate_exclusive_conditions() {
  local conditions="$1"
  local first_condition
  
  # Get first condition to check
  first_condition=$(echo "$conditions" | cut -d',' -f1 | xargs)
  
  case "$first_condition" in
    ~os.*)
      local exclude_os=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_OS" != "$exclude_os" ]
      ;;
    ~arch.*)
      local exclude_arch=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_ARCH" != "$exclude_arch" ]
      ;;
    ~pm.*)
      local exclude_pm=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_PM" != "$exclude_pm" ]
      ;;
    ~distro.*)
      local exclude_distro=$(echo "$first_condition" | cut -d'.' -f2)
      [ "$CURRENT_DISTRO" != "$exclude_distro" ]
      ;;
    *)
      return 1
      ;;
  esac
}

# Check if a package should be installed based on its conditions
# Returns 0 if package should be installed, 1 otherwise
should_install_package() {
  local conditions="$1"
  
  # No conditions means always install
  if [ -z "$conditions" ]; then
    return 0
  fi
  
  # Check if conditions contain negation (exclusive logic)
  case "$conditions" in
    ~*)
      evaluate_exclusive_conditions "$conditions"
      ;;
    *)
      evaluate_inclusive_conditions "$conditions"
      ;;
  esac
}

# Move a file or folder to trash.
# Used to moved files that already exists before create the symlink,
# just in case you need to restore them.
function move_to_trash() {
  if [ -e "$1" ]; then
    filename=$(basename "$1")
    new_filename="$filename-$(date +%s)"

    if [[ "$IS_OSX" == true ]]; then
      # On OSX, use the `trash` command
      mv -f "$1" ~/.Trash/"$new_filename"
      echo "$filename moved to trash, you can restore it from there if needed"
    else if [[ "$IS_LINUX" == true ]]; then
      # On Linux, move to temp folder
      mv -f "$1" /tmp/"$new_filename"

      echo "$filename moved to trash, you can restore it from there if needed"
    fi
  fi
 fi
}

# Link/Copy a file to another location.
# It has 3 modes:
# - symbolic link(default): create a symbolic link to the file. It's usefult to keep file synced with git.
# - copy: created a copy of the file to the specified location.
# - skip: skip the file (do nothing)
function link() {
  if [ "$3" = "copy" ]; then # COPY
    move_to_trash "$2"
    cp -r "$1" "$2"
    echo "🔗 File $2 copied from $1"
    return
  elif [ "$3" = "skip" ]; then # SKIP
    # noop
    return
  else # symbolic link by default
    current_target=$(readlink "$2" 2>/dev/null)
    # Only link if file is not already linked
    if { [ ! -L "$2" ] && [ ! -d "$2" ]; } || [ "$current_target" != "$1" ]; then
      # Create parent directories recursively if they don't exist
      dir_path=$(dirname "$2")
      if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
      fi
      move_to_trash "$2"
      ln -sf "$1" "$2"
      echo "🔗 File $2 linked to $1"
    else
      echo "ℹ️  File $2 is already linked"
    fi
    return
  fi
}

function _command_exists() {
	#_about 'checks for existence of a command'
	#_param '1: command to check'
	#_param '2: (optional) log message to include when command not found'
	#_example '$ _command_exists ls && echo exists'
	#_group 'lib'
	local msg="${2:-Command '$1' does not exist}"
	if type -t "$1" > /dev/null; then
		return 0
	else
		_log_debug "$msg"
		return 1
	fi
}

# Given a filename, returns packages in an array
# Skips empty lines and lines starting with # (comments)
# Evaluates conditional syntax and filters packages accordingly
# ## Usage:
# * Declare an array
#   packages=()
# * Load packages from a file
#   load_packages "$HOME/.dotfiles/linux/packages/common.packages" packages
load_packages() {
    local file="$1"
    local array_name="$2"

    if [ ! -f "$file" ]; then
        echo "File not found: $file" >&2
        return 1
    fi

    # Build string with newlines as separators
    local package_lines=""
    local first_package=true

    while IFS= read -r line; do
        # Skip empty lines and comments
        [ -z "$line" ] && continue
        case "$line" in \#*) continue ;; esac
        
        # Process the line (no comma-separated alternatives for now)
        local alternative=$(echo "$line" | xargs) # trim whitespace
        
        # Parse package name and conditions
        local parse_result
        parse_result=$(parse_package_line "$alternative")
        local package_name="${parse_result%|*}"
        local conditions="${parse_result#*|}"
        
        # Check if this package alternative should be installed
        if should_install_package "$conditions"; then
            if [ "$first_package" = true ]; then
                package_lines="$package_name"
                first_package=false
            else
                package_lines="$package_lines
$package_name"
            fi
        fi
    done < "$file"
    
    # Read each line into array element
    eval "
    $array_name=()
    while IFS= read -r pkg; do
        $array_name+=(\"\$pkg\")
    done << EOF
$package_lines
EOF
"
}

brew_safe_cask() {
  local cask="$1"

  if [[ -z "$cask" ]]; then
    return 0
  fi

  # Not installed → install
  if ! brew list --cask "$cask" &>/dev/null; then
    echo "Installing $cask..."
    brew install --cask "$cask" || true
    return 0
  fi

  # Installed → try upgrade, but never fail
  echo "$cask already installed, checking for upgrade..."
  brew upgrade --cask "$cask" &>/dev/null || true
}

