$ErrorActionPreference = "Stop"

$bashPreexec = Join-Path $env:USERPROFILE ".bash-preexec.sh"
if (-not (Test-Path -LiteralPath $bashPreexec)) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh" -OutFile $bashPreexec
}
