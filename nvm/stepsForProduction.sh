#!/bin/bash

# Set the NVM version to install
NVM_VERSION="v0.40.2"

# Download and run the official NVM installation script
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

# Load NVM immediately into current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Add NVM initialization to shell profile
PROFILE="$HOME/.bashrc"
if [[ $SHELL == *"zsh" ]]; then
  PROFILE="$HOME/.zshrc"
fi

# Ensure idempotent addition to profile
if ! grep -q 'export NVM_DIR="$HOME/.nvm"' "$PROFILE"; then
  {
    echo 'export NVM_DIR="$HOME/.nvm"'
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
  } >> "$PROFILE"
fi

# Install the latest LTS version of Node.js
nvm install --lts

# Set the installed LTS version as default
nvm alias default lts/*
