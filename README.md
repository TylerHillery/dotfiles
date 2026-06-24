# Dotfiles

This repo is managed by mise bootstrap and mise dotfiles.

## Fresh install

Install mise first. Mise is the bootstrap tool for the rest of this repo, so it is intentionally not managed by the repo bootstrap itself.

Windows:

```powershell
winget install jdx.mise --exact --source winget
```

macOS/Linux:

```bash
curl https://mise.run | sh
```

Enable mise's platform config environments from `.miserc.toml`, inspect the active config, then bootstrap:

```bash
mise config
mise bootstrap --dry-run
mise bootstrap --yes
```

## Layout

- `mise.toml`: shared mise settings and tasks
- `mise.macos.toml`: macOS tools, packages, GUI apps, dotfiles, and macOS bootstrap task
- `mise.windows.toml`: Windows tools, winget GUI/system app task, dotfiles, and Windows bootstrap task
- `mise.linux.toml`: Linux and WSL tools, apt packages, dotfiles, and Linux bootstrap task
- `mac/`, `windows/`, `linux/`: platform-specific config files linked by `[dotfiles]`

## Rules

- Use `[tools]` for CLIs and runtimes that mise can manage with shims.
- Use `[bootstrap.packages]` for machine-global OS packages, native libraries, shells, build dependencies, and macOS GUI apps supported by mise providers.
- Use the Windows `tasks.bootstrap` winget loop for Windows GUI apps because `winget:` is not a built-in mise bootstrap package provider in the installed mise version.
- WSL uses the normal Linux config; the WSL config task detects WSL and skips itself on normal Linux.

Platform notes:

- [macOS](mac/README.md)
- [Linux/WSL](linux/README.md)
- [Windows](windows/README.md)
