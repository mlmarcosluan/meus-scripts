#!/bin/bash

   ### Busca e tratamento dos dados
get_dados(){
    # Variáveis locais
    local cidade="$1" 
    local dados=$(curl -s --max-time 30 "https://wttr.in/${cidade}?format=j1&lang=pt") # Dados completos do wttr.in
    local temp_c=$(echo "$dados" | jq -r ".current_condition[0].temp_C") # Temperatura em graus celsius
    local clima_atual=$(echo "$dados" | jq -r ".current_condition[0].lang_pt[0].value")
    local sensa_termica=$(echo "$dados" | jq -r ".current_condition[0].FeelsLikeC")
    local code=$(echo "$dados" | jq -r ".current_condition[0].FeelsLikeC")

    echo "${temp_c}|${clima_atual}|${sensa_termica}|${code}" # Saida da função

}
   
   ### Escolha do icone
get_icon(){
    local code="$1"

    case $code in
        113) # Sol/Limpo
            icon="weather-clear" 
            ;;
        116|119|122) # Nuvens
            icon="weather-overcast" 
            ;;
        143|248|260) # Neblina
            icon="weather-fog"
            ;;
        386|389|392|395|200) # Chuvas fortes
            icon="weather-storm"
            ;;
        179|227|230|323|326|329|332|335|338|368|371) # Agrupando todos os códigos de neve/gelo
            icon="weather-snow"
            ;;
        *) # Qualquer outra coisa geralmente é chuva ou variações de chuva
            icon="weather-showers" 
            ;;
    esac

    echo "$icon"
}

main(){

       ### Variaveis Locais
    local cidade="Sao_Paulo"
    local icon

    # Pega os dados necessários
    IFS="|" read -r temp_c clima_atual sensa_termica code <<< $(get_dados "$cidade")

    # Ecolha do icone
    icon=$(get_icon "code")

       ### Saídas genmon
    echo "<icon>$icon</icon><txt> ${cidade}, ${temp_c}°/${sensa_termica}°</txt><txtclick>gnome-weather</txtclick>"
    echo "<tool>Temperatura atual: ${temp_c}°, Sensção termíca: ${sensa_termica}°
    Clima atual: ${clima_atual}.</tool>"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi