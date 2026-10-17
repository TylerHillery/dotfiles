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

On Linux, normal bootstrap installs the declared apt packages but does not
upgrade unrelated packages or purge unused ones. Run
`mise run maintenance:upgrade` or `mise run maintenance:autoremove` separately when you
want to review apt's proposed changes; both commands prompt before proceeding.

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

List installed VS Code extensions missing from the shared extension list:

```bash
mise run vscode:extensions:missing
```

## OpenCode server

Start:

```bash
systemctl --user enable --now opencode-server.service
sudo tailscale serve --bg --https=443 http://127.0.0.1:4096
```

Stop:

```bash
sudo tailscale serve --https=443 off
systemctl --user disable --now opencode-server.service
```
