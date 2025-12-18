#!/bin/bash

   ###   Função de verificação do status do spotify   ###
get_spotify_status() {
    local status
    status=$(playerctl -p spotify status 2> /dev/null) # o 2> /dev/null cerve para esconder o erro caso tenha

    # Verifica qual o status atual do spotify
    if [[ -z "$status" || "$status" == "No players found" ]]; then # O spotfy esta fechado
        echo "Fechado"
    elif [[ "$status" == "Paused" ]]; then # O spotify está pausado
        echo "Pausado"
    elif [[ "$status" == "Playing" ]]; then # O spotify está em reprodução
        echo "Em repordução"
    fi
}

   ### Função Main   ###
main() {

    # Variáveis locais
    local info
    local status_atual
    
    info=$(playerctl -p spotify metadata --format "{{title}} - {{artist}}")
    status_atual=$(get_spotify_status)
    
    # Saida para o genmon
    echo "<txt>$info</txt>"
    echo "<tool>$status_atual</tool>"
}

main