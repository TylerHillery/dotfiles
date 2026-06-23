install:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./install.ps1

backup:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./backup.ps1

restore:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./restore.ps1

reconcile:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./reconcile-winget.ps1

prune:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./prune-winget.ps1

prune-apply:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./prune-winget.ps1 -Apply

register-backup-task:
	powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./register-backup-task.ps1

all: install
