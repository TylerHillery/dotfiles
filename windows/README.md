# Windows dotfiles

This branch keeps Windows-specific setup separate from the macOS dotfiles.

## Fresh install

Run from Git Bash in `windows/`:

```bash
make install
```

Or run PowerShell from the repo root:

```powershell
.\windows\install.ps1
```

The script installs missing packages from `windows/apps-winget.txt`, refreshes PATH, symlinks tracked settings, installs tools from `windows/mise_config.toml`, installs `opencode-ai` with npm when npm is available, then runs `windows/verify.ps1`.

Git Bash initializes Atuin for `Ctrl+R` search and sources `~/.bash-preexec.sh` before Atuin so Bash history can be recorded. Atuin daemon mode is disabled in `windows/atuin_config.toml` because it caused command hangs on this machine.

## Link tracked settings

Windows settings are symlinked into their live locations. Changes made by apps or by editing files in this repo update the same files.

To relink without reinstalling packages:

```bash
make link
```

Or:

```powershell
.\windows\link.ps1
```

If a destination already exists and is not a symlink, `link.ps1` moves it aside to a timestamped `.dotfiles-backup-*` path before creating the symlink.

Windows symlink creation requires Developer Mode or an elevated shell.

## Apply packages only

To install missing winget packages without relinking settings:

```bash
make packages
```

This checks each package in `windows/apps-winget.txt` with `winget list` and skips packages that are already installed.

## Verify current machine

To check expected commands and symlinked config files:

```bash
make verify
```

This runs `windows/verify.ps1` and checks for `git`, `code`, `atuin`, `mise`, `make`, `winget`, and the main symlinked config files.

## Reconcile winget packages

To check whether you installed packages outside of the dotfiles flow:

```powershell
.\windows\reconcile-winget.ps1
```

This writes `windows/apps-winget.current.txt` and `windows/winget-export.current.json`, then compares them against `windows/apps-winget.txt`.

Packages in `windows/apps-winget.ignore.txt` are ignored during comparison. Use that for Windows defaults, runtimes, and winget dependencies that you do not want to manage directly.

If the current machine state is what you want to track, run the command printed by the script to replace `windows/apps-winget.txt`.

## Prune winget packages

To list installed winget packages that are not tracked in `windows/apps-winget.txt`:

```powershell
.\windows\prune-winget.ps1
```

To uninstall those untracked packages:

```powershell
.\windows\prune-winget.ps1 -Apply
```

Packages in `windows/apps-winget.ignore.txt` are never pruned.

WSL has two config locations:

- `%USERPROFILE%\.wslconfig`: Windows-side global WSL VM settings. This is symlinked from `windows/wslconfig` if it exists.
- `/etc/wsl.conf`: per-distro Linux-side settings. This is tracked in `linux/wsl.conf` and applied from inside WSL with `make wsl-conf`.

Restart WSL after changing either WSL config:

```powershell
wsl --shutdown
```

Linux shell dotfiles live in the top-level `linux/` directory and are managed from that directory inside WSL/Linux.

## Tracked settings

- `windows/packages.winget`: declarative package config kept in sync with `apps-winget.txt`
- `windows/apps-winget.txt`: package list used by install/reconcile/prune
- `windows/apps-winget.ignore.txt`: winget packages ignored during reconcile
- `windows/invoke-retry.ps1`: retry helper used around flaky install operations
- `windows/refresh-path.ps1`: refreshes current PowerShell PATH from registry after installs
- `windows/link.ps1`: symlinks tracked config files into live locations
- `windows/verify.ps1`: validates expected commands and symlinked config files
- `windows/bashrc`: Git Bash startup config, linked to `~/.bashrc`
- `windows/bash_profile`: Git Bash login config, linked to `~/.bash_profile`
- `windows/inputrc`: Git Bash/readline config, linked to `~/.inputrc`
- `windows/gitconfig`: Git config, linked to `~/.gitconfig`
- `windows/wslconfig`: optional global WSL config, linked to `~/.wslconfig`
- `windows/powershell_profile.ps1`: PowerShell profile, linked to `~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1`
- `windows/mise_config.toml`: mise global tool config, linked to `%LOCALAPPDATA%\mise\config\config.toml`
- `windows/atuin_config.toml`: Atuin config, linked to `~/.config/atuin/config.toml`
- `windows/vscode/settings.jsonc`: VS Code user settings
- `windows/vscode/keybindings.jsonc`: VS Code keybindings
- `windows/vscode/extensions.txt`: VS Code extensions
- `windows/terminal/settings.json`: Windows Terminal settings
- `windows/powertoys/`: PowerToys settings, including Keyboard Manager

## Optional make targets

`make` is installed by `windows/install.ps1` via `ezwinports.make`. Run these from `windows/` in Git Bash:

```bash
make install
make link
make packages
make verify
make reconcile
make prune
make prune-apply
```
