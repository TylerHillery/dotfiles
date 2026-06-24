$ErrorActionPreference = "Stop"

$PowerShellProfile = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

function Link-IfExists {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        "Skipped missing $Source"
        return
    }

    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }

    if (Test-Path -LiteralPath $Destination) {
        $item = Get-Item -LiteralPath $Destination -Force
        $isLink = ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0

        if ($isLink) {
            Remove-Item -LiteralPath $Destination -Force
        } else {
            $backup = "$Destination.dotfiles-backup-$(Get-Date -Format yyyyMMddHHmmss)"
            Move-Item -LiteralPath $Destination -Destination $backup
            "Moved existing $Destination to $backup"
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
    } catch {
        throw "Failed to create symlink '$Destination' -> '$Source'. Run this from an elevated shell or enable Windows Developer Mode. Original error: $($_.Exception.Message)"
    }
    "Linked $Destination -> $Source"
}

Link-IfExists "$PSScriptRoot\bashrc" "$env:USERPROFILE\.bashrc"
Link-IfExists "$PSScriptRoot\bash_profile" "$env:USERPROFILE\.bash_profile"
Link-IfExists "$PSScriptRoot\inputrc" "$env:USERPROFILE\.inputrc"
Link-IfExists "$PSScriptRoot\gitconfig" "$env:USERPROFILE\.gitconfig"
Link-IfExists "$PSScriptRoot\wslconfig" "$env:USERPROFILE\.wslconfig"
Link-IfExists "$PSScriptRoot\powershell_profile.ps1" $PowerShellProfile
Link-IfExists "$PSScriptRoot\mise_config.toml" "$env:LOCALAPPDATA\mise\config\config.toml"
Link-IfExists "$PSScriptRoot\atuin_config.toml" "$env:USERPROFILE\.config\atuin\config.toml"
Link-IfExists "$PSScriptRoot\vscode\settings.jsonc" "$env:APPDATA\Code\User\settings.json"
Link-IfExists "$PSScriptRoot\vscode\keybindings.jsonc" "$env:APPDATA\Code\User\keybindings.json"
Link-IfExists "$PSScriptRoot\terminal\settings.json" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Link-IfExists "$PSScriptRoot\powertoys\settings.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\settings.json"
Link-IfExists "$PSScriptRoot\powertoys\Keyboard Manager\settings.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\settings.json"
Link-IfExists "$PSScriptRoot\powertoys\Keyboard Manager\default.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\default.json"
Link-IfExists "$PSScriptRoot\powertoys\Keyboard Manager\editorSettings.json" "$env:LOCALAPPDATA\Microsoft\PowerToys\Keyboard Manager\editorSettings.json"

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

"Close and reopen Git Bash, Windows Terminal, VS Code, and PowerToys after linking."
