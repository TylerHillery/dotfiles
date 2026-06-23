$ErrorActionPreference = "Stop"

$AppsFile = Join-Path $PSScriptRoot "apps-winget.txt"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is required before running this script."
}

Get-Content -LiteralPath $AppsFile | ForEach-Object {
    $id = $_.Trim()
    if ($id -and -not $id.StartsWith("#")) {
        winget install --id $id --exact --source winget --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            "winget install failed for $id; continuing"
        }
    }
}

& "$PSScriptRoot\restore.ps1"

$bashPreexec = Join-Path $env:USERPROFILE ".bash-preexec.sh"
if (-not (Test-Path -LiteralPath $bashPreexec)) {
    Invoke-WebRequest `
        -Uri "https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh" `
        -OutFile $bashPreexec
}

$env:PATH = "$env:USERPROFILE\AppData\Local\mise\shims;$env:PATH"
if (Get-Command mise -ErrorAction SilentlyContinue) {
    $miseConfig = Join-Path $PSScriptRoot "mise_config.toml"
    $miseConfigDir = Join-Path $env:LOCALAPPDATA "mise\config"
    if (-not (Test-Path -LiteralPath $miseConfigDir)) {
        New-Item -ItemType Directory -Path $miseConfigDir | Out-Null
    }
    Copy-Item -LiteralPath $miseConfig -Destination (Join-Path $miseConfigDir "config.toml") -Force
    mise install
    mise reshim
}

if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install -g opencode-ai
}

if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
    "wsl command not found; install WSL from Windows Optional Features or Microsoft Store."
} else {
    "WSL is available. Run 'wsl --install' manually if you have not already initialized a distro."
}
