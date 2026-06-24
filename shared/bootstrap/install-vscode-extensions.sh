#!/usr/bin/env bash
set -euo pipefail

extensions_file="${1:?usage: install-vscode-extensions.sh <extensions-file>}"

if ! command -v code >/dev/null 2>&1; then
	echo "code not found; skipping VS Code extensions"
	exit 0
fi

if [ ! -f "$extensions_file" ]; then
	echo "VS Code extensions file not found: $extensions_file"
	exit 0
fi

while IFS= read -r extension; do
	case "$extension" in "" | \#*) continue ;; esac
	code --install-extension "$extension"
done <"$extensions_file"
