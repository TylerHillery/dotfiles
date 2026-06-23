$ErrorActionPreference = "Stop"

$checks = @(
    @{ Name = "git"; Command = "git" },
    @{ Name = "code"; Command = "code" },
    @{ Name = "atuin"; Command = "atuin" },
    @{ Name = "mise"; Command = "mise" },
    @{ Name = "make"; Command = "make" },
    @{ Name = "winget"; Command = "winget" }
)

$missing = @()

foreach ($check in $checks) {
    if (Get-Command $check.Command -ErrorAction SilentlyContinue) {
        "OK: $($check.Name)"
    } else {
        "MISSING: $($check.Name)"
        $missing += $check.Name
    }
}

$files = @(
    "$env:USERPROFILE\.bashrc",
    "$env:USERPROFILE\.bash_profile",
    "$env:USERPROFILE\.inputrc",
    "$env:USERPROFILE\.gitconfig",
    "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1",
    "$env:LOCALAPPDATA\mise\config\config.toml",
    "$env:USERPROFILE\.config\atuin\config.toml",
    "$env:APPDATA\Code\User\settings.json",
    "$env:APPDATA\Code\User\keybindings.json"
)

foreach ($file in $files) {
    if (Test-Path -LiteralPath $file) {
        "OK: $file"
    } else {
        "MISSING: $file"
        $missing += $file
    }
}

$appsFile = Join-Path $PSScriptRoot "apps-winget.txt"
$packagesConfig = Join-Path $PSScriptRoot "packages.winget"

if ((Test-Path -LiteralPath $appsFile) -and (Test-Path -LiteralPath $packagesConfig)) {
    $apps = Get-Content -LiteralPath $appsFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith("#") } |
        Sort-Object -Unique

    $packages = Get-Content -LiteralPath $packagesConfig |
        ForEach-Object {
            if ($_ -match "^\s+id:\s+(.+?)\s*$") {
                $Matches[1].Trim()
            }
        } |
        Where-Object { $_ } |
        Sort-Object -Unique

    $appSet = @{}
    $packageSet = @{}
    $apps | ForEach-Object { $appSet[$_] = $true }
    $packages | ForEach-Object { $packageSet[$_] = $true }

    $missingFromPackages = $apps | Where-Object { -not $packageSet.ContainsKey($_) }
    $missingFromApps = $packages | Where-Object { -not $appSet.ContainsKey($_) }

    if ($missingFromPackages -or $missingFromApps) {
        if ($missingFromPackages) {
            $missingFromPackages | ForEach-Object { "MISSING FROM packages.winget: $_" }
        }
        if ($missingFromApps) {
            $missingFromApps | ForEach-Object { "MISSING FROM apps-winget.txt: $_" }
        }
        $missing += "package source drift"
    } else {
        "OK: apps-winget.txt matches packages.winget"
    }
}

if ($missing.Count -gt 0) {
    throw "Verification failed. Missing $($missing.Count) item(s)."
}

"Verification passed."
