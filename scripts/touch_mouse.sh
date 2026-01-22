#!/bin/bash

id_dispositivos(){
    local touch_id
    local mouse_id

    touch_id=$(xinput list | awk -F'id=' '/ELAN0B00:00 04F3:30EA Touchpad/ {print int($2)}')
    mouse_id=$(xinput list | awk -F'id=' '/USB Gaming Mouse/ && /pointer/ && !/Consumer Control/ {print int($2)}')

    if [ -z "$mouse_id" ]; then
        mouse_id="Desconectado"
    fi
    echo "${touch_id}|${mouse_id}"
}

estado_dispo(){
    local id_touch=$1
    local id_mouse=$2
    local estado_touch
    local estado_mouse

    # Estado do Touchpad
    estado_touch=$(xinput list-props $id_touch | grep "Device Enabled" | awk '{print $4}')

    # Estado do Mouse
    if [[ "$id_mouse" == "Desconectado" ]]; then
        estado_mouse="Desconectado"
    else
        estado_mouse=$(xinput list-props $id_mouse | grep "Device Enabled" | awk '{print $4}')
    fi

    echo "${estado_touch}|${estado_mouse}"
}

main(){
    local touch_id
    local mouse_id

    # Id dos dipositivos
    IFS="|" read -r touch_id mouse_id <<< "$(id_dispositivos)"

    # Estado dos dispositivos
    IFS="|" read -r estado_touch estado_mouse <<< "$(estado_dispo $touch_id $mouse_id)"
    
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi