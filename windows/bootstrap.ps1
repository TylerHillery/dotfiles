$ErrorActionPreference = "Stop"

mise dot apply --yes

& (Join-Path $PSScriptRoot "scripts\install-bash-preexec.ps1")

mise run bootstrap:nvim
mise run bootstrap:vscode-extensions
