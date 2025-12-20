#!/bin/bash

cal_uso_cpu(){
# Ler os dados no /proc/stat
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
total=$((user+nice+system+idle))

# Calcular total inicial e idle inicial
prev_idle=$((idle + iowait))
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

# Espera 1 segundo para calcular a taxa
sleep 1

# Ler os dados FINAIS (segunda leitura)
read cpu user nice system idle iowait irq softirq steal guest < /proc/stat

# Calcular total final e idle final
curr_idle=$((idle + iowait))
curr_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

# Calcular a diferença dos dados coletados de uso
diff_idle=$((curr_idle - prev_idle))
diff_total=$((curr_total - prev_total))

# 5. Cálculo de uso
cpu_usage=$(( (100 * (diff_total - diff_idle)) / (diff_total) ))
printf -v cpu_usage_format "%3s" $cpu_usage
}


# Top processo
top_procs=$(ps axch -o cmd:15,%cpu --sort=-%cpu | head -5 | awk '{printf "%s %s %% \n", $1, $2}')

#Saída no formato Genmon
echo "<txt>CPU: $cpu_usage_format %</txt><txtclick>xfce4-taskmanager</txtclick>"
echo "<tool>Top CPU:

${top_procs}</tool>"