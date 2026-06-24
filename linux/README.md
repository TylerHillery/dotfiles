# Linux and WSL dotfiles

Linux setup is declared in `../mise.linux.toml` and loaded automatically by mise because `.miserc.toml` enables `auto_env`.

## Normal Linux

```bash
mise config
mise bootstrap --dry-run
mise bootstrap --yes
```

## WSL

WSL uses the normal Linux config. The bootstrap task detects WSL and applies `linux/wsl.conf` only when running inside WSL:

```bash
mise config
mise bootstrap --dry-run
mise bootstrap --yes
```

Restart WSL from Windows after changing `linux/wsl.conf`:

```powershell
wsl --shutdown
```

## What lives here

- `zshrc`: linked to `~/.zshrc`
- `gitconfig`: linked to `~/.gitconfig`
- `atuin_config.toml`: linked to `~/.config/atuin/config.toml`
- `tmux.conf`: linked to `~/.tmux.conf`
- `wsl.conf`: applied by Linux bootstrap only when running inside WSL

The oh-my-zsh theme is shared across macOS and Linux in `../shared/zsh/tylerhillery.zsh-theme`.
