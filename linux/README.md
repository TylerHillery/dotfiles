# Linux dotfiles

Linux/WSL shell configuration. This uses symlinks like the macOS dotfiles and uses zsh with oh-my-zsh.

## Fresh install

From inside the Linux distro:

```bash
cd /mnt/c/Users/Tyler/code/personal/dotfiles/linux
make install
```

This installs packages from `apt-packages.txt`, installs non-apt tools, installs oh-my-zsh if missing, attempts to set zsh as the default shell, and symlinks dotfiles.

To only relink dotfiles without installing software:

```bash
make dotfiles
```

Close and reopen the shell after linking.

`/etc/wsl.conf` is tracked as `linux/wsl.conf`, but it is a system file and should be copied into place explicitly:

```bash
make wsl-conf
```

Then restart WSL from Windows:

```powershell
wsl --shutdown
```

`apt-packages.txt` supports comments and blank lines. Lines starting with `#` are ignored.

## Tracked settings

- `linux/zshrc`: linked to `~/.zshrc`
- `linux/tylerhillery.zsh-theme`: linked to `~/.oh-my-zsh/custom/themes/tylerhillery.zsh-theme`
- `linux/gitconfig`: linked to `~/.gitconfig`
- `linux/atuin_config.toml`: linked to `~/.config/atuin/config.toml`
- `linux/mise_config.toml`: linked to `~/.config/mise/config.toml`
- `linux/tmux.conf`: linked to `~/.tmux.conf`
- `linux/wsl.conf`: copied to `/etc/wsl.conf` with `make wsl-conf`
- `linux/apt-packages.txt`: apt packages installed by `install.sh`
