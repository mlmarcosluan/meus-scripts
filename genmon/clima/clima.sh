#!/bin/bash

   ### Configurações ###
# Apenas troca o nome da cidade que esta entre "" sem acentos
CIDADE="Campinas"
REGIAO="Sao Paulo" 

   ### Busca e tratamento dos dados ###
# Busca dos dados
DADOS=$(curl -s --max-time 30 "https://wttr.in/${CIDADE}?format=j1&lang=pt") # Dados completos do wttr.in
TEMP_C=$(echo "$DADOS" | jq -r ".current_condition[0].temp_C") # Temperatura em graus celsius
CLIMA_ATUAL=$(echo "$DADOS" | jq -r ".current_condition[0].lang_pt[0].value")
SENSA_TERMICA=$(echo "$DADOS" | jq -r ".current_condition[0].FeelsLikeC")

   ### Verificações ###
# Verificando a cidade e região
DADOS_CIDADE=$(echo "$DADOS" | jq -r ".nearest_area[0].areaName[0].value")
DADOS_REGIAO=$(echo "$DADOS" | jq -r ".nearest_area[0].region[0].value")

if [ "$DADOS_CIDADE" == "$CIDADE"  ]; then
   : # Tudo certo até aqui
else
   echo "<txt>Erro...</txt>"
   echo "<tool>Conflito entre a cidade alvo e a cidade alcançada, deveria ser ${CIDADE}, mas é ${DADOS_CIDADE}.</tool>"
   exit 1 # Para o script, ja que tem um erro
fi

# Caso esteja sem internt apenas exibe "Erro"
if [ -z "$DADOS" ]; then
    # echo "<txt>Erro.</txt>"
    # echo "<tool>Sem conexão</tool>"
    # exit 1
    echo "Erro."
    exit 1
fi

    ### Escolha do icone ###   
# Verificação de qual icone deverá aparecer no painel

code=$(echo "$DADOS" | jq -r ".current_condition[0].weatherCode")

case $code in
    113) # Sol/Limpo
        ICON="weather-clear" 
        ;;
    116|119|122) # Nuvens
        ICON="weather-overcast" 
        ;;
    143|248|260) # Neblina
        ICON="weather-fog"
        ;;
    386|389|392|395|200) # Chuvas fortes
        ICON="weather-storm"
        ;;
    179|227|230|323|326|329|332|335|338|368|371) # Agrupando todos os códigos de neve/gelo
        ICON="weather-snow"
        ;;
    *) # Qualquer outra coisa geralmente é chuva ou variações de chuva
        ICON="weather-showers" 
        ;;
esac


   ### Saídas genmon
echo "<icon>$ICON</icon><txt> ${CIDADE}, ${TEMP_C}°/${SENSA_TERMICA}°</txt>"
echo "<tool>Temperatura atual: ${TEMP_C}°, Sensção termíca: ${SENSA_TERMICA}°
Clima atual: ${CLIMA_ATUAL}.</tool>"


