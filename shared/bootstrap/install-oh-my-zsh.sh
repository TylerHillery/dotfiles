#!/usr/bin/env bash
set -euo pipefail

zsh_dir="$HOME/.oh-my-zsh"
if [ -f "$zsh_dir/oh-my-zsh.sh" ]; then
	echo "oh-my-zsh already installed"
	exit 0
fi

echo "Installing oh-my-zsh without replacing existing custom files..."
mkdir -p "$HOME/.cache" "$zsh_dir"
temporary="$(mktemp -d "$HOME/.cache/oh-my-zsh.XXXXXXXX")"
trap 'rm -rf -- "$temporary"' EXIT
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$temporary/oh-my-zsh"
cp -a -n "$temporary/oh-my-zsh/." "$zsh_dir/"
test -f "$zsh_dir/oh-my-zsh.sh"
