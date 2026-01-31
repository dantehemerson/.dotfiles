#!/bin/bash

# Add external apt repositories for GitHub CLI and other tools
# This script sets up GPG keys and apt sources

echo "🔹 Setting up apt repositories..."

# GitHub CLI repository setup
# Source: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
if ! command -v gh &> /dev/null; then
    echo "  → Adding GitHub CLI repository..."
    
    # Install wget if not present (required for key download)
    if ! type -p wget >/dev/null; then
        sudo apt-get update
        sudo apt-get install wget -y
    fi
    
    # Create keyrings directory
    sudo mkdir -p -m 755 /etc/apt/keyrings
    
    # Download and install GitHub CLI GPG key
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    
    # Add GitHub CLI repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
        sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    
    echo "  ✓ GitHub CLI repository added"
else
    echo "  ✓ GitHub CLI already installed, skipping repository setup"
fi

# Add more repositories here as needed
echo "🔹 Updating apt cache after adding repositories..."
sudo apt-get update

echo "✓ Repository setup complete"
