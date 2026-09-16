# Dotfiles

This repo is managed by mise.

## Fresh install

Install mise first. Mise is the bootstrap tool for the rest of this repo, so it is intentionally not managed by the repo bootstrap itself.

Windows:

```powershell
winget install jdx.mise --exact --source winget
winget install Git.Git --exact --source winget
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

## Common commands

Inspect managed state:

```bash
mise bootstrap status
mise dot status
mise dot diff
```

Apply repo dotfiles to live targets:

```bash
mise dot apply --yes
```

On Windows, copy changed live targets back into the repo when symlinks or apps drift:

```bash
mise run dotfiles:update-differs -- --DryRun
mise run dotfiles:update-differs
```

## OpenCode server

Start:

```bash
systemctl --user enable --now opencode-server.service
tailscale serve --bg --https=443 http://127.0.0.1:4096
```

Stop:

```bash
tailscale serve --https=443 off
systemctl --user disable --now opencode-server.service
```
