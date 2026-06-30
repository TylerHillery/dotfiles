param(
    [switch]$DryRun,
    [switch]$Yes
)

$ErrorActionPreference = "Stop"

function Assert-NoUnstagedChanges {
    $status = git status --porcelain
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to inspect git status."
    }

    $unstaged = @(
        $status | Where-Object {
            $_ -match '^\?\?' -or ($_.Length -gt 1 -and $_[1] -ne ' ')
        }
    )

    if ($unstaged.Count -gt 0) {
        "Refusing to update dotfiles while changes are unstaged or untracked."
        "Stage or stash these files first:"
        $unstaged | ForEach-Object { "  $_" }
        exit 1
    }
}

function Invoke-PreCommitFormatting {
    "Running pre-commit formatting hooks..."
    mise exec -- prek run --all-files
    if ($LASTEXITCODE -eq 0) {
        return
    }

    "Formatting hooks changed files or failed; running once more to verify."
    mise exec -- prek run --all-files
    if ($LASTEXITCODE -ne 0) {
        throw "Pre-commit formatting hooks did not pass."
    }
}

if (-not $DryRun) {
    Assert-NoUnstagedChanges
}

$status = mise dotfiles status
if ($LASTEXITCODE -ne 0) {
    throw "Failed to inspect mise dotfiles status."
}

$targets = @()
foreach ($line in $status) {
    if ($line -match '^Target\s+Mode\s+Source\s+State$' -or [string]::IsNullOrWhiteSpace($line)) {
        continue
    }

    $columns = $line -split '\s{2,}', 4
    if ($columns.Count -lt 4) {
        continue
    }

    $target = $columns[0].Trim()
    $state = $columns[3].Trim()

    if ($state -like 'differs*') {
        $targets += $target
    }
}

if ($targets.Count -eq 0) {
    "No differing dotfiles found."
    exit 0
}

"Differing dotfiles:"
$targets | ForEach-Object { "  $_" }

$args = @('dotfiles', 'add')
if ($DryRun) {
    $args += '--dry-run'
}
if ($Yes) {
    $args += '--yes'
}
$args += $targets

if (-not $DryRun -and -not $Yes) {
    $answer = Read-Host "Update dotfile sources from these live targets? [y/N]"
    if ($answer -notmatch '^(y|yes)$') {
        "Cancelled."
        exit 0
    }
}

mise @args
if ($LASTEXITCODE -ne 0) {
    throw "mise dotfiles add failed."
}

if (-not $DryRun) {
    Invoke-PreCommitFormatting
}
