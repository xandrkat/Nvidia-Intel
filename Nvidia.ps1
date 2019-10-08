# Nvidia
# Turn off services
# Отключить службы
Get-Service -ServiceName NvTelemetryContainer | Stop-Service
Get-Service -ServiceName NvTelemetryContainer | Set-Service -StartupType Manual
# Remove diagnostics tracking scheduled tasks
# Удалить задачи диагностического отслеживания
Unregister-ScheduledTask -TaskName NvProfile* -Confirm:$false
Unregister-ScheduledTask -TaskName NvTmMon* -Confirm:$false
Unregister-ScheduledTask -TaskName NvTmRep* -Confirm:$false
# Delete recovery batch files
# Удалить bat-файлы восстановления телеметрии
Remove-Item -Path $env:SystemRoot\NvContainerRecovery.bat -Force
Remove-Item -Path $env:SystemRoot\NvTelemetryContainerRecovery.bat -Force
# Turn off Nvidia control panel
# Отключить Панель управления
Get-Service -ServiceName NVDisplay.ContainerLocalSystem | Stop-Service
Get-Service -ServiceName NVDisplay.ContainerLocalSystem | Set-Service -StartupType Manual
Stop-Process -Name NVDisplay.Container -Force
# Turn off Ansel
# Отключить Ansel
Start-Process -FilePath "$env:ProgramFiles\NVIDIA Corporation\Ansel\Tools\NvCameraEnable.exe" -ArgumentList off
# Delete telemetry logs
# Удалить логи телеметрии
Remove-Item -Path $env:ProgramData\NVIDIA\NvTelemetryContainer.log* -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path "$env:ProgramData\NVIDIA Corporation\NvTelemetry" -Force | Remove-Item -Recurse -Force

# Errors output
# Вывод ошибок
Write-Host "`nErrors" -BackgroundColor Red
($Error | ForEach-Object -Process {
	[PSCustomObject] @{
		Line = $_.InvocationInfo.ScriptLineNumber
		Error = $_.Exception.Message
	}
} | Sort-Object -Property Line | Format-Table -AutoSize -Wrap | Out-String).Trim()
