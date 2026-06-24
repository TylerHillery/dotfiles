#!/usr/bin/env bash
set -euo pipefail

if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
	echo "oh-my-zsh already installed"
	exit 0
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
	echo "Removing incomplete oh-my-zsh install..."
	rm -rf "$HOME/.oh-my-zsh"
fi

echo "Installing oh-my-zsh..."
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
