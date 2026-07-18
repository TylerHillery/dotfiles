#!/usr/bin/env bash
set -euo pipefail

if ! grep -qiE '(microsoft|wsl)' /proc/sys/kernel/osrelease /proc/version 2>/dev/null; then
	echo "Not running inside WSL; skipping win32yank"
	exit 0
fi

install_dir="$HOME/.local/bin"
target="$install_dir/win32yank.exe"

if command -v win32yank.exe >/dev/null 2>&1; then
	echo "win32yank.exe already installed"
	exit 0
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

zip_file="$tmp_dir/win32yank.zip"
curl -fsSL \
	"https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip" \
	-o "$zip_file"

if command -v unzip >/dev/null 2>&1; then
	unzip -q "$zip_file" -d "$tmp_dir"
elif command -v powershell.exe >/dev/null 2>&1; then
	powershell.exe -NoProfile -Command \
		"Expand-Archive -Path '$(wslpath -w "$zip_file")' -DestinationPath '$(wslpath -w "$tmp_dir")' -Force" >/dev/null
else
	echo "Need unzip or powershell.exe to extract win32yank" >&2
	exit 1
fi

mkdir -p "$install_dir"
install -m 755 "$tmp_dir/win32yank.exe" "$target"
echo "Installed $target"
