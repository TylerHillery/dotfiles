install:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./install.ps1

backup:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./backup.ps1

restore:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./restore.ps1

restore-wsl:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./restore.ps1 -RestoreWslDistroConfig

reconcile:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./reconcile-winget.ps1

prune:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./prune-winget.ps1

prune-apply:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./prune-winget.ps1 -Apply

register-backup-task:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./register-backup-task.ps1

packages:
	winget configure --file ./packages.winget --accept-configuration-agreements --disable-interactivity

refresh-path:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./refresh-path.ps1

verify:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./verify.ps1

task-list:
	powershell.exe -NoProfile -Command "Get-ScheduledTask -TaskName '*Dotfiles*' | ForEach-Object { \$$info = \$$_ | Get-ScheduledTaskInfo; [pscustomobject]@{ TaskName = \$$_.TaskName; State = \$$_.State; LastRunTime = \$$info.LastRunTime; LastTaskResult = \$$info.LastTaskResult; NextRunTime = \$$info.NextRunTime } } | Format-Table -AutoSize"

task-info:
	powershell.exe -NoProfile -Command "Get-ScheduledTask -TaskName 'Dotfiles Windows Backup' | Get-ScheduledTaskInfo"

task-logs:
	powershell.exe -NoProfile -Command "Get-WinEvent -LogName 'Microsoft-Windows-TaskScheduler/Operational' -MaxEvents 20 | Where-Object { \$$_.Properties -match 'Dotfiles Windows Backup' } | Select-Object TimeCreated, Id, Message | Format-Table -AutoSize"

all: install
