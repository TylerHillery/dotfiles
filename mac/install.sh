#!/bin/bash

echo "Installing non-Homebrew software..."

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Claude
if ! command -v claude &> /dev/null; then
    echo "Installing Claude..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "Claude already installed"
fi

# OpenCode
if ! command -v opencode &> /dev/null; then
    echo "Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash
else
    echo "OpenCode already installed"
fi

# Ampcode
if ! command -v amp &> /dev/null; then
    echo "Installing Ampcode..."
    curl -fsSL https://ampcode.com/install.sh | bash
else
    echo "Ampcode already installed"
fi



echo "Non-Homebrew software installation complete!"