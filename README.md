# Dotfiles

This repo is managed by mise bootstrap and mise dotfiles.

## Fresh install

Install mise first. Mise is the bootstrap tool for the rest of this repo, so it is intentionally not managed by the repo bootstrap itself.

Windows:

```powershell
winget install jdx.mise --exact --source winget
winget install Git.Git mise --exact --source winget
```

macOS/Linux:

```bash
curl https://mise.run/zsh | sh
```

Enable mise's platform config environments from `.miserc.toml`, inspect the active config, then bootstrap:

```bash
git clone https://github.com/TylerHillery/dotfiles
cd dotfiles
mise config
mise bootstrap --dry-run
mise bootstrap --yes
```

Platform notes:
- [macOS](mac/README.md)
- [Linux/WSL](linux/README.md)
- [Windows](windows/README.md)
