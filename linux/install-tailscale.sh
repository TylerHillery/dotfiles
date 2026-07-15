#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
	echo "Not running on Linux; skipping Tailscale"
	exit 0
fi

if grep -qiE '(microsoft|wsl)' /proc/sys/kernel/osrelease /proc/version 2>/dev/null; then
	cat <<'EOF'
Installing Tailscale inside WSL 2 is optional and advanced.
Tailscale recommends running it on the Windows host only for general use.
Use this only when you want WSL to appear as its own Linux node, such as for Tailscale SSH.
EOF
fi

if ! command -v tailscale >/dev/null 2>&1; then
	curl -fsSL https://tailscale.com/install.sh | sh
fi

if command -v systemctl >/dev/null 2>&1; then
	if ! systemctl is-system-running >/dev/null 2>&1 && ! systemctl is-system-running 2>/dev/null | grep -qE 'degraded|running'; then
		echo "systemd is not running; start WSL again after applying linux/wsl.conf"
	else
		sudo systemctl enable --now tailscaled
	fi
else
	echo "systemctl not found; start tailscaled manually before running tailscale up"
fi

if tailscale status >/dev/null 2>&1; then
	echo "Tailscale is already connected"
	exit 0
fi

hostname="$(hostname)-wsl"
echo "Tailscale is installed. To add this WSL distro as its own SSH target, run:"
echo "  sudo tailscale up --ssh --hostname ${hostname}"
