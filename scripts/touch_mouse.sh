#!/bin/bash

id_dispositivos(){
    local touch_id
    local mouse_id

    touch_id=$(xinput list | awk -F'id=' '/ELAN0B00:00 04F3:30EA Touchpad/ {print int($2)}')
    mouse_id=$(xinput list | awk -F'id=' '/USB Gaming Mouse/ && /pointer/ && !/Consumer Control/ {print int($2)}')

    echo "${touch_id}|${mouse_id}"
}

main(){
    local touch_id
    local mouse_id

    IFS="|" read -r touch_id mouse_id <<< "$(id_dispositivos)"
    
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi