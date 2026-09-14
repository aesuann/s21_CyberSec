from scapy.all import IP, TCP, send
tcp = TCP()
tcp.sport = 12344     # исходящий порт
tcp.dport = 12345     # целевой порт
data = "Dear Steel Cat! This is no attack, it's my humster Pinkie you should track"

# Собираем пакет: IP + TCP + данные
packet = IP(dst="172.22.80.1") / TCP(dport=12345) / data
send(packet)