# get_fw_rules.ps1

$ruleNames = @(
    "Block_http_conn",
    "Allow_rdp_conn",
    "Block_ftp_conn",
    "Block_ping_conn"
)

# Правила через CIM
$rules = Get-CimInstance -ClassName MSFT_NetFirewallRule -Namespace root/standardcimv2 -Filter "DisplayName LIKE 'Block_http_conn' OR DisplayName LIKE 'Allow_rdp_conn' OR DisplayName LIKE 'Block_ftp_conn' OR DisplayName LIKE 'Block_ping_conn'" -ErrorAction SilentlyContinue

if ($null -eq $rules) {
    exit 1
}

$result = foreach ($rule in $rules) {
    # Параметры по имени правила
    switch ($rule.DisplayName) {
        "Block_http_conn" {
            $protocol = "TCP"
            $localPort = "80"
            $remotePort = "Any"
        }
        "Allow_rdp_conn" {
            $protocol = "TCP"
            $localPort = "3389"
            $remotePort = "Any"
        }
        "Block_ftp_conn" {
            $protocol = "TCP"
            $localPort = "21"
            $remotePort = "Any"
        }
        "Block_ping_conn" {
            $protocol = "ICMPv4"
            $localPort = "Any"
            $remotePort = "Any"
        }
        default {
            $protocol = "Any"
            $localPort = "Any"
            $remotePort = "Any"
        }
    }

    [PSCustomObject]@{
        Название       = $rule.DisplayName
        Включено       = $rule.Enabled
        Протокол       = $protocol
        ЛокальныйПорт  = $localPort
        УдаленныйПорт  = $remotePort
        Действие       = $rule.Action
        Профиль        = $rule.Profile -join ", "
    }
}

# Вывод
$result | Format-Table -AutoSize

# Сохранение в result.txt
$result | ForEach-Object {
    "Правило: $($_.Название)"
    "Включено: $($_.Включено)"
    "Протокол: $($_.Протокол)"
    "Локальный порт: $($_.ЛокальныйПорт)"
    "Удалённый порт: $($_.УдаленныйПорт)"
    "Действие: $($_.Действие)"
    "Профиль: $($_.Профиль)"
    ""
} | Out-File -FilePath "result.txt" -Encoding UTF8

Write-Host "Результат сохранён в result.txt" -ForegroundColor Green