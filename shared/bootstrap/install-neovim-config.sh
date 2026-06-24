#!/usr/bin/env bash
set -euo pipefail

nvim_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim_config_branch="mac"

if [ -d "$nvim_config_dir/.git" ]; then
	echo "Neovim config already installed"
	git -C "$nvim_config_dir" fetch origin "$nvim_config_branch"
	git -C "$nvim_config_dir" checkout "$nvim_config_branch"
	exit 0
fi

echo "Installing Neovim config..."
mkdir -p "$(dirname "$nvim_config_dir")"
git clone https://github.com/TylerHillery/kickstart.nvim.git "$nvim_config_dir"
git -C "$nvim_config_dir" checkout "$nvim_config_branch"
