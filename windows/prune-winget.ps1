param(
    [switch]$Apply
)

$ErrorActionPreference = "Stop"

$AppsFile = Join-Path $PSScriptRoot "apps-winget.txt"
$IgnoreFile = Join-Path $PSScriptRoot "apps-winget.ignore.txt"
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

$tracked = Get-Content -LiteralPath $AppsFile |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith("#") }

$trackedSet = @{}
$ignoreSet = @{}
$tracked | ForEach-Object { $trackedSet[$_] = $true }
$ignore | ForEach-Object { $ignoreSet[$_] = $true }

$extra = @($export.Sources.Packages.PackageIdentifier) |
    Sort-Object -Unique |
    Where-Object { -not $trackedSet.ContainsKey($_) -and -not $ignoreSet.ContainsKey($_) }

if (-not $extra) {
    "No untracked winget packages found."
    return
}

"Untracked winget packages:"
$extra | ForEach-Object { "  $_" }

if (-not $Apply) {
    ""
    "Dry run only. To uninstall these packages, rerun with -Apply:"
    "  .\windows\prune-winget.ps1 -Apply"
    return
}

""
"Uninstalling untracked winget packages..."
$extra | ForEach-Object {
    winget uninstall --id $_ --exact --source winget --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        "winget uninstall failed for $_; continuing"
    }
}
