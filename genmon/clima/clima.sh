#!/bin/bash

   ### Configurações ###
# Apenas troca o nome da cidade que esta entre "" sem acentos
CIDADE="Campinas"
REGIAO="Sao Paulo" 

   ### Busca e tratamento dos dados ###
# Busca dos dados
DADOS=$(curl -s --max-time 30 "https://wttr.in/${CIDADE}?format=j1") # Dados completos do wttr.in
TEMP_C=$(echo "$DADOS" | jq -r ".current_condition[0].temp_C") # Temperatura em graus celsius
CLIMA_ATUAL=$(echo "$DADOS" | jq -r ".current_condition[0].weatherDesc[0].value")
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

   ### Dicionario de tradução do climas para português
# Clear > Limpo
# Partly cloudy > Parcialmente nublado

   ### Saídas genmon
echo "<txt>${CIDADE}, ${TEMP_C}°/${SENSA_TERMICA}°</txt>"
echo "<tool>Temperatura atual: ${TEMP_C}°, Sensção termíca: ${SENSA_TERMICA}°
Clima atual: ${CLIMA_ATUAL}.</tool>"


