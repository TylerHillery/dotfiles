$ErrorActionPreference = "Stop"

try {
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = $utf8NoBom
    $OutputEncoding = $utf8NoBom
} catch {
    "Could not force UTF-8 console output: $($_.Exception.Message)"
}

$AppsFile = Join-Path $PSScriptRoot "apps-winget.txt"
. (Join-Path $PSScriptRoot "invoke-retry.ps1")

function Test-WingetPackageInstalled {
    param(
        [Parameter(Mandatory = $true)][string]$Id
    )

    winget list --id $Id --exact --source winget --disable-interactivity *> $null
    return $LASTEXITCODE -eq 0
}

if (-not (Test-Path -LiteralPath $AppsFile)) {
    throw "Package list not found: $AppsFile"
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is required before running this script."
}

"Installing missing packages from apps-winget.txt..."

Get-Content -LiteralPath $AppsFile | ForEach-Object {
    $id = $_.Trim()
    if ($id -and -not $id.StartsWith("#")) {
        if (Test-WingetPackageInstalled -Id $id) {
            "Already installed: $id"
        } else {
            Invoke-Retry -Name "winget install $id" -ScriptBlock {
                "Installing: $id"
                winget install --id $id --exact --source winget --disable-interactivity --accept-package-agreements --accept-source-agreements
                if ($LASTEXITCODE -ne 0) {
                    throw "winget install failed for $id with exit code $LASTEXITCODE"
                }
            }
        }
    }
}
