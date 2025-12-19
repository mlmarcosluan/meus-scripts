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
    
    status_atual=$(get_spotify_status)
    # Se o status do spotify for diferente de "Em Reprodução" entra no segundo if, caso contrario sai do primeiro if sem fazer nada
    if [[ "$status_atual" != "Em repordução" ]]; then # Se o $status_atual é igual a
        if [[ "$status_atual" == "Pausado" ]]; then 
            echo "<txtclick>playerctl -p spotify play</txtclick><txt>$status_atual</txt>"
            echo "<tool>Spotify $status_atual</tool>"
        else # Para outras saidas, como a "Fechado"
            echo "<txtclick>spotify</txtclick><txt>Spotify fechado</txt>"
        fi
        return
    fi

    info=$(playerctl -p spotify metadata --format "{{title}} - {{artist}}")
    
    # Saida para o genmon
    echo "<txtclick>playerctl -p spotify pause</txtclick><txt>$info</txt>"
    echo "<tool>$status_atual</tool>"
}

main