$ErrorActionPreference = "Stop"

& (Join-Path $PSScriptRoot "scripts\install-winget-packages.ps1")
& (Join-Path $PSScriptRoot "scripts\install-bash-preexec.ps1")

mise run bootstrap:vscode-extensions
