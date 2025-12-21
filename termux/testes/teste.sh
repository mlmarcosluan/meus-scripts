#!/data/data/com.termux/files/usr/bin/bash

echo "Hello Word."

# Para impedirmos que o terminal feche logo após mostrar a menssagem vamos usar o read com os seguintes opções:

# -n 1: aceita apenas 1 caractere
# -s: não mostra o caractere na tela (silent)
# -r: trata a barra invertida como caractere normal
# -p: mensagem
read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
echo ""