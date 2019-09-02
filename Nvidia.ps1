# Disable services
# Отключить службы
Get-Service -ServiceName NvTelemetryContainer | Stop-Service
Get-Service -ServiceName NvTelemetryContainer | Set-Service -StartupType Manual
# Remove diagnostics tracking scheduled tasks
# Отключить задачи
Unregister-ScheduledTask -TaskName NvProfile* -Confirm:$false
Unregister-ScheduledTask -TaskName NvTmMon* -Confirm:$false
Unregister-ScheduledTask -TaskName NvTmRep* -Confirm:$false
# Disable Nvidia control panel
# Отключить Панель управления
Get-Service -ServiceName NVDisplay.ContainerLocalSystem | Stop-Service
Get-Service -ServiceName NVDisplay.ContainerLocalSystem | Set-Service -StartupType Manual
Stop-Process -Name NVDisplay.Container -Force -ErrorAction SilentlyContinue
# Clean up old Nvidia driver folder
# Becomes impossible to remove the driver through the control panel
# Очистить файлы установки
# Становится невозможно удалить драйвер через Панель управления
Get-ChildItem -Path "${env:ProgramFiles}\NVIDIA Corporation\Installer2" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
# Turn off Ansel
# Отключить Ansel
Start-Process -FilePath "$env:ProgramFiles\NVIDIA Corporation\Ansel\Tools\NvCameraEnable.exe" -ArgumentList off
