$ErrorActionPreference = "Stop"

$PowerShellProfile = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

function Copy-IfExists {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    if (Test-Path -LiteralPath $Source) {
        $parent = Split-Path -Parent $Destination
        if (-not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent | Out-Null
        }
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        "Backed up $Source"
    } else {
        "Skipped missing $Source"
    }
}

Copy-IfExists "$env:USERPROFILE\.bashrc" "$PSScriptRoot\bashrc"
Copy-IfExists "$env:USERPROFILE\.bash_profile" "$PSScriptRoot\bash_profile"
Copy-IfExists "$env:USERPROFILE\.inputrc" "$PSScriptRoot\inputrc"
Copy-IfExists "$env:USERPROFILE\.gitconfig" "$PSScriptRoot\gitconfig"
Copy-IfExists $PowerShellProfile "$PSScriptRoot\powershell_profile.ps1"
Copy-IfExists "$env:LOCALAPPDATA\mise\config\config.toml" "$PSScriptRoot\mise_config.toml"
Copy-IfExists "$env:USERPROFILE\.config\atuin\config.toml" "$PSScriptRoot\atuin_config.toml"
Copy-IfExists "$env:APPDATA\Code\User\settings.json" "$PSScriptRoot\vscode\settings.jsonc"
Copy-IfExists "$env:APPDATA\Code\User\keybindings.json" "$PSScriptRoot\vscode\keybindings.jsonc"
Copy-IfExists "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "$PSScriptRoot\terminal\settings.json"
Copy-IfExists "$env:LOCALAPPDATA\Microsoft\PowerToys\settings.json" "$PSScriptRoot\powertoys\settings.json"
Copy-IfExists "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\settings.json" "$PSScriptRoot\powertoys\Keyboard Manager\settings.json"
Copy-IfExists "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\default.json" "$PSScriptRoot\powertoys\Keyboard Manager\default.json"
Copy-IfExists "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\editorSettings.json" "$PSScriptRoot\powertoys\Keyboard Manager\editorSettings.json"

if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget export --output "$PSScriptRoot\winget-export.json" --source winget --accept-source-agreements | Out-Null
    "Backed up winget package export"
} else {
    "Skipped winget export because winget is not on PATH"
}

if (Get-Command code -ErrorAction SilentlyContinue) {
    $extensionsFile = "$PSScriptRoot\vscode\extensions.txt"
    code --list-extensions | Sort-Object | Set-Content -LiteralPath $extensionsFile
    "Backed up VS Code extensions"
} else {
    "Skipped VS Code extensions because code is not on PATH"
}
