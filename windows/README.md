# Windows dotfiles

Windows setup is declared in `../mise.windows.toml` and loaded automatically by mise because `.miserc.toml` enables `auto_env`.

## Fresh install

Install mise first, then run from the repo root:

```powershell
winget install jdx.mise --exact --source winget
mise config
mise bootstrap --dry-run
mise bootstrap --yes
```

Windows GUI apps are installed by `windows/bootstrap.ps1` from the official WinGet DSC configuration in `windows/packages.winget` because `winget:` is not a built-in mise bootstrap package provider in the installed mise version.

## What lives here

- `bashrc`, `bash_profile`, `inputrc`: Git Bash config
- `gitconfig`: linked to `~/.gitconfig`
- `powershell_profile.ps1`: linked to the Windows PowerShell profile path
- `atuin_config.toml`: linked to `~/.config/atuin/config.toml`
- `vscode/settings.jsonc`, `vscode/keybindings.jsonc`: VS Code settings
- `winget/settings.json`: WinGet settings, including configuration experimental feature support
- `terminal/settings.json`: Windows Terminal settings
- `powertoys/`: PowerToys settings, including Keyboard Manager
- `bootstrap.ps1`: Windows bootstrap orchestrator called by mise
- `scripts/`: isolated Windows bootstrap steps
- `packages.winget`: official WinGet DSC package configuration applied by the Windows bootstrap script

VS Code extensions are shared across platforms in `../shared/vscode/extensions.txt`.

Git Bash initializes Atuin for `Ctrl+R` search and sources `~/.bash-preexec.sh` before Atuin so Bash history can be recorded. Atuin daemon mode is disabled in `windows/atuin_config.toml` because it caused command hangs on this machine.
