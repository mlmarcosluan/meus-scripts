#!/bin/bash

# Tentar detectar a interface ativa
IFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

# Se IFACE estiver vazia retorna Offline
if [ -z "$IFACE" ]; then
	echo "<txt>Offline</txt>"
fi

# Download
# Função para ler bytes
get_bytes_dow() {
	cat /sys/class/net/$IFACE/statistics/rx_bytes
}

# Leitura 1
bytes1_dow=$(get_bytes_dow)

# Espara
sleep 0.5

# Leitura 2
bytes2_dow=$(get_bytes_dow)

# Calculo de velocidade de b/s
bps_dow=$(( bytes2_dow - bytes1_dow ))
#Calculo de velocidade de KB/s
kbps_dow=$(( bps_dow / 1024 ))

# Se for maior que 1024KB, mostra MB
if [ $kbps_dow -gt 1024 ]; then
	mbps_dow=$(echo "scale=1; $kbps_dow / 1024" | bc | awk '{printf "%3.1f", $0}')
	speed_dow="$mbps_dow MB/s"
else
	speed_dow=$(echo "$kbps_dow" | awk '{printf "%3.1f KB/s", $0}')
fi

# upload
# Função para ler bytes
get_bytes_up() {
	cat /sys/class/net/$IFACE/statistics/tx_bytes
}

# Leitura 1
bytes1_up=$(get_bytes_up)

# Espara
sleep 0.5

# Leitura 2
bytes2_up=$(get_bytes_up)

# Calculo de velocidade de b/s
bps_up=$(( bytes2_up - bytes1_up ))
#Calculo de velocidade de KB/s
kbps_up=$(( bps_up / 1024 ))

# Se for maior que 1024KB, mostra MB
if [ $kbps_up -gt 1024 ]; then
	mbps_up=$(echo "scale=1; $kbps_up / 1024" | bc | awk '{printf "%3.1f", $0}')
	speed_up="$mbps_up MB/s"
else
	speed_up=$(echo "$kbps_up" | awk '{printf "%3.1f KB/s", $0}')
fi

#Saída no formato Genmon
echo "<txt> ↓ $speed_dow | ↑ $speed_up</txt><txtclick>nm-connection-editor</txtclick>"
echo "<tool>Interface> $IFACE</tool>"