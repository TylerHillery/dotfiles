$ErrorActionPreference = "Stop"

function Get-EnvFromRegistry {
    param(
        [Parameter(Mandatory = $true)][ValidateSet("Machine", "User")][string]$Scope,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if ($Scope -eq "Machine") {
        $key = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    } else {
        $key = "HKCU:\Environment"
    }

    try {
        return (Get-ItemProperty -Path $key -Name $Name -ErrorAction Stop).$Name
    } catch {
        return $null
    }
}

$machinePath = Get-EnvFromRegistry -Scope Machine -Name "Path"
$userPath = Get-EnvFromRegistry -Scope User -Name "Path"

$pathEntries = @($machinePath, $userPath) |
    Where-Object { $_ } |
    ForEach-Object { $_.TrimEnd(";") } |
    Where-Object { $_ } |
    ForEach-Object { $_ -split ";" } |
    Where-Object { $_ -and $_.Trim() } |
    Select-Object -Unique

$env:Path = ($pathEntries -join ";")

foreach ($name in @("PATHEXT", "PSModulePath")) {
    $machineValue = Get-EnvFromRegistry -Scope Machine -Name $name
    $userValue = Get-EnvFromRegistry -Scope User -Name $name
    $values = @($machineValue, $userValue) |
        Where-Object { $_ } |
        ForEach-Object { $_.TrimEnd(";") } |
        Where-Object { $_ }

    if ($values) {
        Set-Item -Path "Env:$name" -Value ($values -join ";")
    }
}

"Refreshed PATH from registry ($($pathEntries.Count) entries)."
