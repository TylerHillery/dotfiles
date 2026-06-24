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

$links = @(
    @{ Source = "$PSScriptRoot\bashrc"; Destination = "$env:USERPROFILE\.bashrc" },
    @{ Source = "$PSScriptRoot\bash_profile"; Destination = "$env:USERPROFILE\.bash_profile" },
    @{ Source = "$PSScriptRoot\inputrc"; Destination = "$env:USERPROFILE\.inputrc" },
    @{ Source = "$PSScriptRoot\gitconfig"; Destination = "$env:USERPROFILE\.gitconfig" },
    @{ Source = "$PSScriptRoot\powershell_profile.ps1"; Destination = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" },
    @{ Source = "$PSScriptRoot\mise_config.toml"; Destination = "$env:LOCALAPPDATA\mise\config\config.toml" },
    @{ Source = "$PSScriptRoot\atuin_config.toml"; Destination = "$env:USERPROFILE\.config\atuin\config.toml" },
    @{ Source = "$PSScriptRoot\vscode\settings.jsonc"; Destination = "$env:APPDATA\Code\User\settings.json" },
    @{ Source = "$PSScriptRoot\vscode\keybindings.jsonc"; Destination = "$env:APPDATA\Code\User\keybindings.json" },
    @{ Source = "$PSScriptRoot\terminal\settings.json"; Destination = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" },
    @{ Source = "$PSScriptRoot\powertoys\settings.json"; Destination = "$env:LOCALAPPDATA\Microsoft\PowerToys\settings.json" },
    @{ Source = "$PSScriptRoot\powertoys\Keyboard Manager\settings.json"; Destination = "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\settings.json" },
    @{ Source = "$PSScriptRoot\powertoys\Keyboard Manager\default.json"; Destination = "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\default.json" },
    @{ Source = "$PSScriptRoot\powertoys\Keyboard Manager\editorSettings.json"; Destination = "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\editorSettings.json" }
)

foreach ($link in $links) {
    if (-not (Test-Path -LiteralPath $link.Source)) {
        continue
    }

    if (Test-Path -LiteralPath $link.Destination) {
        $item = Get-Item -LiteralPath $link.Destination -Force
        $isLink = ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
        if ($isLink) {
            "OK: $($link.Destination) -> $($link.Source)"
        } else {
            "NOT LINKED: $($link.Destination)"
            $missing += $link.Destination
        }
    } else {
        "MISSING: $($link.Destination)"
        $missing += $link.Destination
    }
}

$trackedWslConfig = Join-Path $PSScriptRoot "wslconfig"
if (Test-Path -LiteralPath $trackedWslConfig) {
    $liveWslConfig = "$env:USERPROFILE\.wslconfig"
    if (Test-Path -LiteralPath $liveWslConfig) {
        $item = Get-Item -LiteralPath $liveWslConfig -Force
        $isLink = ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
        if ($isLink) {
            "OK: $liveWslConfig -> $trackedWslConfig"
        } else {
            "NOT LINKED: $liveWslConfig"
            $missing += $liveWslConfig
        }
    } else {
        "MISSING: $liveWslConfig"
        $missing += $liveWslConfig
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
