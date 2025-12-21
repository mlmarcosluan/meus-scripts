#!/data/data/com.termux/files/usr/bin/bash

echo "Hello Word."

escolha=$(termux-dialog radio -v "Video, Audio" -t "Selecione.")
escolha2=$(termux-dialog radio -v "MP3, MP4" -t "Selecione a extenção do arquivo.")
echo "$escolha"
echo "$escolha2"

read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
echo ""