#!/usr/bin/env bash
set -euo pipefail

if ! grep -qiE '(microsoft|wsl)' /proc/sys/kernel/osrelease /proc/version 2>/dev/null; then
	echo "Not running inside WSL; skipping /etc/wsl.conf"
	exit 0
fi

sudo install -m 644 linux/wsl.conf /etc/wsl.conf
echo "Applied linux/wsl.conf to /etc/wsl.conf"
