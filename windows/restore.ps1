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
        "Restored $Destination"
    } else {
        "Skipped missing $Source"
    }
}

Copy-IfExists "$PSScriptRoot\bashrc" "$env:USERPROFILE\.bashrc"
Copy-IfExists "$PSScriptRoot\bash_profile" "$env:USERPROFILE\.bash_profile"
Copy-IfExists "$PSScriptRoot\inputrc" "$env:USERPROFILE\.inputrc"
Copy-IfExists "$PSScriptRoot\gitconfig" "$env:USERPROFILE\.gitconfig"
Copy-IfExists "$PSScriptRoot\powershell_profile.ps1" $PowerShellProfile
Copy-IfExists "$PSScriptRoot\mise_config.toml" "$env:LOCALAPPDATA\mise\config\config.toml"
Copy-IfExists "$PSScriptRoot\atuin_config.toml" "$env:USERPROFILE\.config\atuin\config.toml"
Copy-IfExists "$PSScriptRoot\vscode\settings.jsonc" "$env:APPDATA\Code\User\settings.json"
Copy-IfExists "$PSScriptRoot\vscode\keybindings.jsonc" "$env:APPDATA\Code\User\keybindings.json"
Copy-IfExists "$PSScriptRoot\terminal\settings.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-IfExists "$PSScriptRoot\powertoys\settings.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\settings.json"
Copy-IfExists "$PSScriptRoot\powertoys\Keyboard Manager\settings.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\settings.json"
Copy-IfExists "$PSScriptRoot\powertoys\Keyboard Manager\default.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\default.json"
Copy-IfExists "$PSScriptRoot\powertoys\Keyboard Manager\editorSettings.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\editorSettings.json"

$extensionsFile = "$PSScriptRoot\vscode\extensions.txt"
if ((Test-Path -LiteralPath $extensionsFile) -and (Get-Command code -ErrorAction SilentlyContinue)) {
    Get-Content -LiteralPath $extensionsFile | ForEach-Object {
        $extension = $_.Trim()
        if ($extension -and -not $extension.StartsWith("#")) {
            code --install-extension $extension
        }
    }
} elseif (Test-Path -LiteralPath $extensionsFile) {
    "Skipped VS Code extensions because code is not on PATH"
}

"Close and reopen Git Bash, Windows Terminal, VS Code, and PowerToys after restore."
