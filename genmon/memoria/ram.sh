#!/bin/bash

# Pegar dados do free
total=$(free -m | grep Mem | awk '{print $2}')
used=$(free -m | grep Mem | awk '{print $3}')
percent=$(( (100 * used) / total ))

printf -v percent_format "%2s" $percent

# Pegar lista dos 5 processos que mais usam a memoria
LISTA=$(ps axo %mem,comm --sort=-%mem | head -n 6 | tail -n 5 | awk '{printf "%.1f%%  %s\n", $1, $2}')

#Saída no formato Genmon
echo "<txt>RAM: $percent_format %</txt><txtclick>xfce4-taskmanager</txtclick>"
echo "<tool>RAM Usada: $used MiB / $total MiB

$LISTA</tool>"
