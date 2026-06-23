$ErrorActionPreference = "Stop"

$AppsFile = Join-Path $PSScriptRoot "apps-winget.txt"
$IgnoreFile = Join-Path $PSScriptRoot "apps-winget.ignore.txt"
$CurrentFile = Join-Path $PSScriptRoot "apps-winget.current.txt"
$ExportFile = Join-Path $PSScriptRoot "winget-export.current.json"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is required before running this script."
}

"Exporting current winget state..."
winget export --output $ExportFile --source winget --accept-source-agreements | Out-Null

$export = Get-Content -Raw -LiteralPath $ExportFile | ConvertFrom-Json
$ignore = @()
if (Test-Path -LiteralPath $IgnoreFile) {
    $ignore = Get-Content -LiteralPath $IgnoreFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith("#") }
}

$ignoreSet = @{}
$ignore | ForEach-Object { $ignoreSet[$_] = $true }

$current = @($export.Sources.Packages.PackageIdentifier) |
    Where-Object { -not $ignoreSet.ContainsKey($_) } |
    Sort-Object -Unique
$tracked = Get-Content -LiteralPath $AppsFile |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith("#") } |
    Where-Object { -not $ignoreSet.ContainsKey($_) } |
    Sort-Object -Unique

$current | Set-Content -LiteralPath $CurrentFile

$currentSet = @{}
$trackedSet = @{}

$current | ForEach-Object { $currentSet[$_] = $true }
$tracked | ForEach-Object { $trackedSet[$_] = $true }

$missing = $tracked | Where-Object { -not $currentSet.ContainsKey($_) }
$extra = $current | Where-Object { -not $trackedSet.ContainsKey($_) }

""
"Differences between apps-winget.txt and currently installed winget packages:"
"< tracked but not installed"
"> installed but not tracked"
""

if ($missing) {
    $missing | ForEach-Object { "< $_" }
}

if ($extra) {
    $extra | ForEach-Object { "> $_" }
}

if (-not $missing -and -not $extra) {
    "No differences found."
}

""
"Current package list written to $CurrentFile"
"Current winget export written to $ExportFile"
"Ignored package list read from $IgnoreFile"
""
"To replace your tracked app list with current state:"
"  Copy-Item -LiteralPath '$CurrentFile' -Destination '$AppsFile' -Force"
""
"To clean up temporary reconcile files:"
"  Remove-Item -LiteralPath '$CurrentFile', '$ExportFile'"
