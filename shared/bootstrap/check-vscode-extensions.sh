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

untracked_extensions="$(comm -23 "$installed_extensions" "$tracked_extensions")"
not_installed_extensions="$(comm -13 "$installed_extensions" "$tracked_extensions")"

if [ -z "$untracked_extensions" ] && [ -z "$not_installed_extensions" ]; then
	echo "Installed VS Code extensions match $extensions_file."
	exit 0
fi

if [ -n "$untracked_extensions" ]; then
	echo "Installed VS Code extensions not in $extensions_file (consider adding):"
	echo "$untracked_extensions"
fi

if [ -n "$not_installed_extensions" ]; then
	if [ -n "$untracked_extensions" ]; then
		echo
	fi
	echo "Extensions in $extensions_file not installed (consider installing or removing):"
	echo "$not_installed_extensions"
fi
