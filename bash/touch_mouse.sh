#!/bin/bash

# --- CONFIGURAÇÕES DE AMBIENTE (Crucial para Udev) ---
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
export DISPLAY=:0
export XAUTHORITY=/home/usuario/.Xauthority

# Pega o ID do usuário 'usuario' para achar o endereço do DBUS correto
USER_ID=$(id -u usuario)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${USER_ID}/bus"

sleep 2

# Função que busca os id dos dispositivos
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

# Função que verifica o estado atual do dispositivo
estado_dispo(){
    local id_touch=$1
    local id_mouse=$2
    local estado_touch
    local estado_mouse

    # Estado do Touchpad
    estado_touch=$(xinput list-props $id_touch | grep "Device Enabled" | awk '{print $4}')

    # Estado do Mouse
    if [[ "$id_mouse" == "Desconectado" ]]; then
        estado_mouse=0
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
    
    if [[ "$estado_mouse" == "1" ]]; then # Mouse estão ativado
        if [[ "$estado_touch" == "1" ]]; then # Mouse e touch ativos
            xinput disable $touch_id # Desativando o touch
            notify-send -t 2000 "Touchpad" "Desativado" --icon=input-touchpad-off # Notificação
        else # Mouse ativo e touch desativado, faz nada
            exit 1
        fi
    else # Mouse desativado
        if [[ "$estado_touch" == "0" ]]; then # Mouse e touch desativado
            xinput enable $touch_id # Ativando o touch
            notify-send -t 2000 "Touchpad" "Ativado" --icon=input-touchpad-on # Notificação
        else # Mouse desativado e touch ativado, faz nada
            exit 1
        fi
    fi
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi


# Configurações
# Crie a regra em /etc/udev/ruler.d
# Exemplo de regra:
# sudo nano /etc/udev/rules.d/99-touchpad-control.rules
# Dentro do arquivo digite:
# ACTION=="add|remove", SUBSYSTEM=="input", KERNEL=="mouse*", RUN+="/usr/bin/sudo -u marcos /bin/bash /home/caminho/completo/script.sh"