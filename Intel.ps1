# Intel
# Stop processes
# Остановить процессы
Stop-Process -Name igfx* -Force -ErrorAction SilentlyContinue
# Turn off services
# Отключить службы
$services = @(
	"cphs",
	"cplspcon",
	"igfxCUIService2.0.0.0",
	"Intel(R) Capability Licensing Service TCP IP Interface",
	"Intel(R) TPM Provisioning Service",
	"jhi_service",
	"LMS"
)
Get-Service -Name $services | Stop-Service
Get-Service -Name $services | Set-Service -StartupType Manual
# Remove $env:SystemDrive\Intel folder
# Удалить папку $env:SystemDrive\Intel
Remove-Item -Path $env:SystemDrive\Intel -Recurse -Force

# Errors output
# Вывод ошибок
Write-Host "`nErrors" -BackgroundColor Red
($Error | ForEach-Object -Process {
	[PSCustomObject] @{
		Line = $_.InvocationInfo.ScriptLineNumber
		Error = $_.Exception.Message
	}
} | Sort-Object -Property Line | Format-Table -AutoSize -Wrap | Out-String).Trim()
