#!/data/data/com.termux/files/usr/bin/bash

echo "Hello Word."

escolha=$(termux-dialog radio -v "Video, Audio" -t "Selecione")

echo "$escolha"

read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
echo ""