#!/bin/bash

   ### Função Main   ###
main() {

    local info
    info=$(playerctl -p spotify metadata --format "{{title}} - {{artist}}")

    # Saida para o genmon
    echo "<txt>$info</txt>"
}

main