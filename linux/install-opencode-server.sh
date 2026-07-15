#!/usr/bin/env bash
set -euo pipefail

if ! command -v systemctl >/dev/null 2>&1; then
	echo "systemctl not found; cannot install user service"
	exit 1
fi

if ! systemctl --user status >/dev/null 2>&1; then
	echo "systemd user services are not available. In WSL, run mise run bootstrap:wsl-conf, then wsl --shutdown from PowerShell."
	exit 1
fi

service_dir="$HOME/.config/systemd/user"
repo_dir="$(pwd)"
service_src="$repo_dir/linux/systemd/user/opencode-server.service"
service_dst="$service_dir/opencode-server.service"

mkdir -p "$service_dir"
ln -sf "$service_src" "$service_dst"

systemctl --user daemon-reload
systemctl --user enable --now opencode-server.service

echo "OpenCode server is running on http://127.0.0.1:4096"
echo "Expose it over Tailscale with:"
echo "  tailscale serve --bg --https=443 http://127.0.0.1:4096"
echo "If that is denied, run once:"
echo "  sudo tailscale set --operator=$USER"
