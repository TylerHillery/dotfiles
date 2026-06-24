# macOS dotfiles

macOS setup is declared in `../mise.macos.toml` and loaded automatically by mise because `.miserc.toml` enables `auto_env`.

## Fresh install

```bash
mise config
mise bootstrap --dry-run
mise bootstrap --yes
```

## What lives here

- `zshrc`: linked to `~/.zshrc`
- `gitconfig`: linked to `~/.gitconfig`
- `atuin_config.toml`: linked to `~/.config/atuin/config.toml`
- `tmux.conf`: linked to `~/.tmux.conf`
- `ghostty_config` and `vim.ghostty`: linked into `~/.config/ghostty`
- `vscode_settings.jsonc`, `vscode_keybindings.jsonc`: VS Code settings

VS Code extensions are shared across platforms in `../shared/vscode/extensions.txt`.

The oh-my-zsh theme is shared across macOS and Linux in `../shared/zsh/tylerhillery.zsh-theme`.

macOS GUI apps are declared as `brew-cask:*` entries in `../mise.macos.toml`.
