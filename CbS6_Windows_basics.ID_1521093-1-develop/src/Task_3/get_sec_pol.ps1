# get_sec_pol.ps1

# Проверка на администратора
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin) {
    exit 1
}

# Политики безопасности
Write-Host "Экспорт политик безопасности в secpol_2.txt" -ForegroundColor Green
secedit /export /cfg "secpol_2.txt" /quiet

if ($LASTEXITCODE -eq 0) {
    Write-Host "Файл сохранён: $(Get-Location)\secpol_2.txt" -ForegroundColor Green
}
else {
    Write-Error "Ошибка экспорта. Код: $LASTEXITCODE"
    exit 1
}