#!/usr/bin/env bash
set -euo pipefail

extensions_file="${1:?usage: check-vscode-extensions.sh <extensions-file>}"

if ! command -v code >/dev/null 2>&1; then
	echo "code not found; skipping VS Code extension check"
	exit 0
fi

if [ ! -f "$extensions_file" ]; then
	echo "VS Code extensions file not found: $extensions_file"
	exit 1
fi

tracked_extensions="$(mktemp)"
installed_extensions="$(mktemp)"
trap 'rm -f "$tracked_extensions" "$installed_extensions"' EXIT

grep -vE '^\s*(#|$)' "$extensions_file" |
	tr '[:upper:]' '[:lower:]' |
	sort -u >"$tracked_extensions"

code --list-extensions |
	tr '[:upper:]' '[:lower:]' |
	sort -u >"$installed_extensions"

missing_extensions="$(comm -23 "$installed_extensions" "$tracked_extensions")"

if [ -z "$missing_extensions" ]; then
	echo "All installed VS Code extensions are tracked."
	exit 0
fi

echo "Installed VS Code extensions missing from $extensions_file:"
echo "$missing_extensions"
