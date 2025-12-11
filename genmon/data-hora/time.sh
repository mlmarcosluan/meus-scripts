#!/bin/bash

# Pegando e formatando a data
DATA=$(date "+%A - %d/%m/%Y são %X")

# Programa que vai abrir ao cliclar
APP="/usr/bin/gsimplecal"

# Saida 
echo "<txt> ${DATA^}</txt><txtclick>$APP</txtclick>" # Uso o ^ para colocar a primeira letra em maiúscula
echo "<tool># Futuras atualizações</tool>" # Tenho boas ideias surgindo
