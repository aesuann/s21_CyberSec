#!/bin/bash

# Проверка на root
if [ "$EUID" -ne 0 ]; then
  exit 1
fi

# Установка пакетов
apt update -y
apt install -y cowsay sl

# Создание файла info 
OUTPUT_FILE="info"

# 1. Установленные пакеты
echo "=== УСТАНОВЛЕННЫЕ ПАКЕТЫ ===" > "$OUTPUT_FILE"
dpkg -l >> "$OUTPUT_FILE"

# 2. Запущенные процессы
echo -e "\n\n=== ЗАПУЩЕННЫЕ ПРОЦЕССЫ ===" >> "$OUTPUT_FILE"
ps aux >> "$OUTPUT_FILE"

# 3. Открытые порты
echo -e "\n\n=== ОТКРЫТЫЕ ПОРТЫ ===" >> "$OUTPUT_FILE"
ss -tuln >> "$OUTPUT_FILE"

# 4. Версия ядра и ОС
echo -e "\n\n=== ВЕРСИЯ ЯДРА И ОПЕРАЦИОННОЙ СИСТЕМЫ ===" >> "$OUTPUT_FILE"
uname -a >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat /etc/os-release >> "$OUTPUT_FILE"

# Архивируем в OS_RESULT.tar
tar -cf OS_RESULT.tar "$OUTPUT_FILE"
