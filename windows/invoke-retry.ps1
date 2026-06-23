$ErrorActionPreference = "Stop"

function Invoke-Retry {
    param(
        [Parameter(Mandatory = $true)][scriptblock]$ScriptBlock,
        [string]$Name = "operation",
        [int]$MaxAttempts = 3,
        [int]$InitialDelaySeconds = 5
    )

    $attempt = 0
    $delay = $InitialDelaySeconds

    while ($true) {
        $attempt++
        try {
            "[retry] ${Name}: attempt $attempt/$MaxAttempts"
            & $ScriptBlock
            "[retry] ${Name}: success"
            return
        } catch {
            if ($attempt -ge $MaxAttempts) {
                "[retry] ${Name}: failed after $attempt attempts"
                throw
            }

            "[retry] ${Name}: $($_.Exception.Message); retrying in ${delay}s"
            Start-Sleep -Seconds $delay
            $delay *= 2
        }
    }
}
