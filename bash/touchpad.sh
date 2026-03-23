#!/bin/bash

main(){
    local dispositivo
    local estado

    # Nome do dispositivo
    dispositivo="ELAN0B00:00 04F3:30EA Touchpad"

    # Pegar o estado do dispositivo
    estado=$(xinput list-props "$dispositivo" | grep "Device Enabled" | awk '{print $4}')

    if [ "$estado" -eq 1 ]; then # Touch ativado
        xinput disable "$dispositivo" # Disativando o touch
        notify-send -t 2000 "Touchpad" "Desativado" --icon=input-touchpad-off # Notificação
    else # Touch desativado
        xinput enable "$dispositivo" # Ativando touch
        notify-send -t 2000 "Touchpad" "Ativado" --icon=input-touchpad-on # Notificação
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi