#!/usr/bin/env bash
set -euo pipefail

if [ -x /opt/homebrew/bin/brew ] || command -v brew >/dev/null 2>&1; then
	echo "Homebrew already installed; skipping"
	exit 0
fi

echo "Installing Homebrew..."
/bin/bash -c \
	"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
