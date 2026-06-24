$ErrorActionPreference = "Stop"

$packagesConfig = Join-Path $PSScriptRoot "..\packages.winget"
$wingetSettings = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"

if (Get-Command winget -ErrorAction SilentlyContinue) {
    $wingetSettingsDirectory = Split-Path $wingetSettings -Parent
    New-Item -ItemType Directory -Path $wingetSettingsDirectory -Force | Out-Null

    if (Test-Path $wingetSettings) {
        $settings = Get-Content $wingetSettings -Raw | ConvertFrom-Json
    } else {
        $settings = [pscustomobject]@{}
    }

    if (-not (Get-Member -InputObject $settings -Name experimentalFeatures -MemberType NoteProperty)) {
        $settings | Add-Member -NotePropertyName experimentalFeatures -NotePropertyValue ([pscustomobject]@{})
    }

    foreach ($feature in @("configuration", "configuration03")) {
        if (Get-Member -InputObject $settings.experimentalFeatures -Name $feature -MemberType NoteProperty) {
            $settings.experimentalFeatures.$feature = $true
        } else {
            $settings.experimentalFeatures | Add-Member -NotePropertyName $feature -NotePropertyValue $true
        }
    }

    $settings | ConvertTo-Json -Depth 10 | Set-Content $wingetSettings

    winget configure --file $packagesConfig --accept-configuration-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        throw "winget configure failed with exit code $LASTEXITCODE"
    }
} else {
    "winget not found; skipping Windows package configuration"
}
