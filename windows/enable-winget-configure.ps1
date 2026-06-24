$ErrorActionPreference = "Stop"

winget configure --help *> $null
if ($LASTEXITCODE -ne 0) {
    throw "winget configure is not available. Update App Installer or winget."
}

$output = winget configure --enable 2>&1
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0 -and ($output -notmatch "already enabled")) {
    $output | ForEach-Object { $_ }
    throw "winget configure --enable failed with exit code $exitCode"
}

"winget configure is enabled."
