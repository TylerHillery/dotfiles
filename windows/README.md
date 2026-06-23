# Windows dotfiles

This branch keeps Windows-specific setup separate from the macOS dotfiles.

## Fresh install

Run PowerShell from the repo root:

```powershell
.\windows\install.ps1
```

The script installs apps from `windows/apps-winget.txt`, restores tracked settings, installs tools from `windows/mise_config.toml`, and installs `opencode-ai` with npm when npm is available.

Git Bash initializes Atuin for `Ctrl+R` search and sources `~/.bash-preexec.sh` before Atuin so Bash history can be recorded. Atuin daemon mode is disabled in `windows/atuin_config.toml` because it caused command hangs on this machine.

## Backup current machine state

After changing Windows Terminal, VS Code, PowerToys, `.bashrc`, or `.inputrc`, run:

```powershell
.\windows\backup.ps1
```

Then review and commit the changed files.

## Automatic backup task

To register a Windows scheduled task that runs `windows/backup.ps1` every 12 hours:

```powershell
.\windows\register-backup-task.ps1
```

This only copies live settings into the repo. It does not commit or push changes.

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

```powershell
.\windows\restore.ps1
```

Close and reopen Git Bash, Windows Terminal, VS Code, and PowerToys after restoring.

## Tracked settings

- `windows/apps-winget.txt`: packages installed with winget
- `windows/apps-winget.ignore.txt`: winget packages ignored during reconcile
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

`make` is installed by `windows/install.ps1` via `ezwinports.make`, but the PowerShell scripts above are the primary interface. If `make` is available in Git Bash, you can run these from `windows/`:

```bash
make install
make backup
make restore
make winget-reconcile
make winget-prune
make winget-prune-apply
make register-backup-task
```
