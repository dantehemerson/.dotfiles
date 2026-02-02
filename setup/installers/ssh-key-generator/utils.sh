#!/bin/bash

# Shared utilities for SSH key generation
# Used by macos.sh and linux.sh

# Configuration
GITHUB_EMAIL="18385321+dantehemerson@users.noreply.github.com"
KEY_NAME="id_ed25519_gh"
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$KEY_NAME"
PUB_KEY_PATH="${KEY_PATH}.pub"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if key already exists
check_existing_key() {
  if [ -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}⚠️  SSH key already exists at $KEY_PATH${NC}"
    echo "Delete it first if you want to regenerate."
    return 1
  fi
  return 0
}

# Generate SSH key
generate_key() {
  echo -e "${BLUE}Generating SSH key with Ed25519 algorithm...${NC}"

  # Create .ssh directory if it doesn't exist
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"

  # Generate the key
  ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH" -N ""

  if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to generate SSH key${NC}"
    return 1
  fi

  echo -e "${GREEN}✓ SSH key generated: $KEY_PATH${NC}"
  return 0
}

# Start ssh-agent
start_ssh_agent() {
  echo -e "${BLUE}Starting ssh-agent...${NC}"
  eval "$(ssh-agent -s)"
  if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to start ssh-agent${NC}"
    return 1
  fi
  echo -e "${GREEN}✓ ssh-agent started${NC}"
  return 0
}

# Display the public key
display_public_key() {
  echo ""
  echo -e "${BLUE}Your SSH public key:${NC}"
  echo "--------------------------------------------------------"
  cat "$PUB_KEY_PATH"
  echo "--------------------------------------------------------"
}

# Display next steps
show_next_steps() {
  echo ""
  echo -e "${BLUE}===============================================${NC}"
  echo -e "${GREEN}✓ SSH key setup complete!${NC}"
  echo -e "${BLUE}===============================================${NC}"
  echo ""
  echo -e "${YELLOW}Next steps to add your key to GitHub:${NC}"
  echo ""
  echo "1. Copy the public key shown above"
  echo "2. Go to: https://github.com/settings/keys"
  echo "   (or GitHub → Settings → SSH and GPG keys)"
  echo ""
  echo "3. Click 'New SSH key' button"
  echo "4. Paste your key (starts with ssh-ed25519)"
  echo "5. Give it a title (e.g., '$(hostname)')"
  echo "6. Click 'Add SSH key'"
  echo ""
  echo -e "${BLUE}To test your connection:${NC}"
  echo "  ssh -T git@github.com"
  echo ""
  echo -e "${YELLOW}Note:${NC} If you see a password prompt, enter your passphrase (if set)."
}
