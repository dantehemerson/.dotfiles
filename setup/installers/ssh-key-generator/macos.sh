#!/bin/bash

# SSH Key Generator for macOS
# Based on: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# macOS-specific SSH configuration
configure_ssh_config() {
  local ssh_config="$SSH_DIR/config"

  echo -e "${BLUE}Configuring SSH config for macOS...${NC}"

  # Check if config already contains our GitHub entry
  if [ -f "$ssh_config" ] && grep -q "IdentityFile.*$KEY_NAME" "$ssh_config"; then
    echo -e "${YELLOW}SSH config already contains configuration for $KEY_NAME${NC}"
    return 0
  fi

  # Create or update SSH config
  cat >>"$ssh_config" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_PATH
EOF

  chmod 600 "$ssh_config"
  echo -e "${GREEN}✓ SSH config updated${NC}"
  return 0
}

# Add key to ssh-agent with macOS keychain support
add_key_to_agent() {
  echo -e "${BLUE}Adding SSH key to agent with keychain integration...${NC}"

  # Try modern macOS syntax first (Monterey 12.0+)
  ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null

  if [ $? -ne 0 ]; then
    # Fallback for older macOS versions (pre-Monterey)
    echo -e "${YELLOW}Trying legacy keychain option...${NC}"
    ssh-add -K "$KEY_PATH" 2>/dev/null

    if [ $? -ne 0 ]; then
      # Final fallback - add without keychain
      ssh-add "$KEY_PATH"
    fi
  fi

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ SSH key added to agent${NC}"
  else
    echo -e "${YELLOW}⚠️  Could not add key to agent. You may need to run:${NC}"
    echo "  ssh-add $KEY_PATH"
  fi
}

# Main execution function for macOS
main() {
  echo -e "${BLUE}===============================================${NC}"
  echo -e "${BLUE}======== GitHub SSH Key Generator =============${NC}"
  echo -e "${BLUE}================== macOS ======================${NC}"
  echo -e "${BLUE}===============================================${NC}"
  echo ""

  # Check for existing key
  check_existing_key || exit 1

  # Generate key
  generate_key || exit 1

  # Start ssh-agent
  start_ssh_agent || exit 1

  # Configure SSH for macOS
  configure_ssh_config

  # Add key to agent
  add_key_to_agent

  # Display the public key
  display_public_key

  # Show next steps
  show_next_steps

  return 0
}

# Run main function
main
