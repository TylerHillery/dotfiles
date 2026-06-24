#!/bin/bash

set -e

echo "Installing Linux software..."

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
packages_file="$script_dir/apt-packages.txt"

# apt packages
if command -v apt-get >/dev/null 2>&1; then
  echo "Installing apt packages..."
  sudo apt-get update

  if [ -f "$packages_file" ]; then
    mapfile -t packages < <(grep -vE '^\s*(#|$)' "$packages_file")
    if [ "${#packages[@]}" -gt 0 ]; then
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
    fi
  fi
else
  echo "apt-get not found; skipping package install."
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed"
fi

# OpenCode
if ! command -v opencode &> /dev/null; then
  echo "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
else
  echo "OpenCode already installed"
fi

# Atuin
if ! command -v atuin &> /dev/null; then
  echo "Installing Atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  echo "Atuin already installed"
fi

# Delta
if ! command -v delta &> /dev/null; then
  echo "Installing Delta..."
  tmp_deb="$(mktemp --suffix=.deb)"
  arch="$(dpkg --print-architecture)"
  delta_url="$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest | jq -r --arg arch "$arch" '.assets[] | select(.name | test("^git-delta_.*_" + $arch + "\\.deb$")) | .browser_download_url' | head -n 1)"
  if [ -z "$delta_url" ]; then
    echo "Could not find Delta .deb for architecture: $arch"
    exit 1
  fi
  curl -fsSL "$delta_url" -o "$tmp_deb"
  sudo dpkg -i "$tmp_deb"
  rm -f "$tmp_deb"
else
  echo "Delta already installed"
fi

# Neovim config
nvim_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [ ! -d "$nvim_config_dir/.git" ]; then
  echo "Installing Neovim config..."
  mkdir -p "$(dirname "$nvim_config_dir")"
  git clone https://github.com/TylerHillery/kickstart.nvim.git "$nvim_config_dir"
else
  echo "Neovim config already installed"
fi

# default shell
if command -v zsh >/dev/null 2>&1; then
  zsh_path="$(command -v zsh)"
  current_shell="${SHELL:-}"

  if [ "$current_shell" != "$zsh_path" ]; then
    if command -v chsh >/dev/null 2>&1; then
      sudo chsh -s "$zsh_path" "$USER" || echo "Could not change default shell; run: chsh -s $zsh_path"
    fi
  fi
fi

echo "Linux software installation complete!"
