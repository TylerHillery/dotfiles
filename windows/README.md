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

The script applies `windows/packages.winget` with `winget configure`, refreshes PATH, restores tracked settings, installs tools from `windows/mise_config.toml`, installs `opencode-ai` with npm when npm is available, then runs `windows/verify.ps1`.

If `winget configure` is unavailable, the script falls back to installing packages from `windows/apps-winget.txt`.

Git Bash initializes Atuin for `Ctrl+R` search and sources `~/.bash-preexec.sh` before Atuin so Bash history can be recorded. Atuin daemon mode is disabled in `windows/atuin_config.toml` because it caused command hangs on this machine.

## Backup current machine state

After changing Windows Terminal, VS Code, PowerToys, `.bashrc`, or `.inputrc`, run from Git Bash in `windows/`:

```bash
make backup
```

Or run PowerShell from the repo root:

```powershell
.\windows\backup.ps1
```

Then review and commit the changed files.

## Automatic backup task

To register a Windows scheduled task that runs `windows/backup.ps1` every 12 hours:

```bash
make register-backup-task
```

Or:

```powershell
.\windows\register-backup-task.ps1
```

This only copies live settings into the repo. It does not commit or push changes.

To inspect the backup task from Git Bash:

```bash
make task-list
make task-info
make task-logs
```

`task-list` shows state, last run, result code, and next run. `task-logs` reads recent Task Scheduler operational events.

## Apply packages only

To apply just the declarative winget package config without restoring settings:

```bash
make packages
```

This runs:

```powershell
winget configure --file ./packages.winget --accept-configuration-agreements --disable-interactivity
```

Use this when you only changed `windows/packages.winget` or want to re-apply package state.

## Verify current machine

To check expected commands and restored config files:

```bash
make verify
```

This runs `windows/verify.ps1` and checks for `git`, `code`, `atuin`, `mise`, `make`, `winget`, and the main restored config files.

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

## Restore tracked settings

To apply the repo settings without reinstalling apps:

```bash
make restore
```

Or:

```powershell
.\windows\restore.ps1
```

Close and reopen Git Bash, Windows Terminal, VS Code, and PowerToys after restoring.

## Tracked settings

- `windows/packages.winget`: declarative package config used by `winget configure`
- `windows/apps-winget.txt`: package list used by reconcile/prune and as fallback when `winget configure` is unavailable
- `windows/apps-winget.ignore.txt`: winget packages ignored during reconcile
- `windows/invoke-retry.ps1`: retry helper used around flaky install operations
- `windows/refresh-path.ps1`: refreshes current PowerShell PATH from registry after installs
- `windows/verify.ps1`: validates expected commands and restored config files
- `windows/bashrc`: Git Bash startup config, restored to `~/.bashrc`
- `windows/bash_profile`: Git Bash login config, restored to `~/.bash_profile`
- `windows/inputrc`: Git Bash/readline config, restored to `~/.inputrc`
- `windows/gitconfig`: Git config, restored to `~/.gitconfig`
- `windows/powershell_profile.ps1`: PowerShell profile, restored to `~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1`
- `windows/mise_config.toml`: mise global tool config, restored to `%LOCALAPPDATA%\mise\config\config.toml`
- `windows/atuin_config.toml`: Atuin config, restored to `~/.config/atuin/config.toml`
- `windows/vscode/settings.jsonc`: VS Code user settings
- `windows/vscode/keybindings.jsonc`: VS Code keybindings
- `windows/vscode/extensions.txt`: VS Code extensions
- `windows/terminal/settings.json`: Windows Terminal settings
- `windows/powertoys/`: PowerToys settings, including Keyboard Manager

## Optional make targets

`make` is installed by `windows/install.ps1` via `ezwinports.make`. Run these from `windows/` in Git Bash:

```bash
make install
make backup
make restore
make packages
make refresh-path
make verify
make reconcile
make prune
make prune-apply
make register-backup-task
make task-list
make task-info
make task-logs
```
