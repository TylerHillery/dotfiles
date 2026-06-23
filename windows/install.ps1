$ErrorActionPreference = "Stop"

$AppsFile = Join-Path $PSScriptRoot "apps-winget.txt"
$PackagesConfig = Join-Path $PSScriptRoot "packages.winget"

. (Join-Path $PSScriptRoot "invoke-retry.ps1")

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is required before running this script."
}

if (Test-Path -LiteralPath $PackagesConfig) {
    $canConfigure = $false

    winget configure --help *> $null
    if ($LASTEXITCODE -eq 0) {
        $canConfigure = $true
    }

    if ($canConfigure) {
        Invoke-Retry -Name "winget configure packages" -ScriptBlock {
            winget configure `
                --file $PackagesConfig `
                --accept-configuration-agreements `
                --disable-interactivity

            if ($LASTEXITCODE -ne 0) {
                throw "winget configure failed with exit code $LASTEXITCODE"
            }
        }
    } else {
        "winget configure is unavailable; falling back to apps-winget.txt installs."
    }
}

if (-not (Test-Path -LiteralPath $PackagesConfig) -or -not $canConfigure) {
    Get-Content -LiteralPath $AppsFile | ForEach-Object {
        $id = $_.Trim()
        if ($id -and -not $id.StartsWith("#")) {
            Invoke-Retry -Name "winget install $id" -ScriptBlock {
                winget install --id $id --exact --source winget --accept-package-agreements --accept-source-agreements
                if ($LASTEXITCODE -ne 0) {
                    throw "winget install failed for $id with exit code $LASTEXITCODE"
                }
            }
        }
    }
}

& "$PSScriptRoot\refresh-path.ps1"

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

& "$PSScriptRoot\verify.ps1"
