#!/bin/bash

   ### Configurações ###
# Apenas troca o nome da cidade que esta entre ""
CIDADE="Campinas"

   ### Busca e tratamento dos dados ###
# Busca dos dados
DADOS=$(curl -s --max-time 30 "https://wttr.in/${CIDADE}?format=j1")

   ### Verificar se os dados são da cidade correta
# Verificando a cidade
DADOS_CIDADE=$(echo $DADOS | jq -r ".nearest_area[0].areaName[0].value")

if [ $DADOS_CIDADE == $CIDADE ]; then
   : # Tudo certo até aqui
else
   echo "<txt>Erro...</txt>"
   echo "<tool>Conflito entre a cidade alvo e a cidade alcançada, deveria ser ${CIDADE}, mas é ${DADOS_CIDADE}.</tool>"
   exit 1 # Para o script, ja que tem um erro
fi

### Caso esteja sem internt apenas exibe "Erro"
if [ -z "$DADOS" ]; then
    # echo "<txt>Erro.</txt>"
    # echo "<tool>Sem conexão</tool>"
    # exit 1
    echo "Erro."
    exit 1
fi

echo $DADOS_CIDADE


