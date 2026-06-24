$ErrorActionPreference = "Stop"

$packagesConfig = Join-Path $PSScriptRoot "..\packages.winget"

if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget configure --file $packagesConfig --accept-configuration-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        throw "winget configure failed with exit code $LASTEXITCODE"
    }
} else {
    "winget not found; skipping Windows package configuration"
}
