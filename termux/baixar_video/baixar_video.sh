#!/data/data/com.termux/files/usr/bin/bash 

       # Verifica se o yt-dlp está instalado
verificar_dependecia(){
    # Variáveis locais
    local dependencias
    local erros
    local pacote
    
    dependencias="yt-dlp termux-clipboard-get ffmpeg jq" # Usei o termux-clipboard para verificar se o termux-api está instalado
    erros=0 # Contador de pacotes faltando

    # For para passar por todas as dependencias
    for pacote in $dependencias; do
        if ! command -v "$pacote" &> /dev/null; then
            if [[ "$pacote" == "termux-clipboard-get" ]];then 
                echo "termux-api não encontrado. Instale com \"pkg install termux-api\"."
                ((erros++)) # Aumenta o contador de pacotes faltando
            else
                echo "$pacote não encontrado. Instale com \"pkg install ${pacote}\"."
                ((erros++)) # Aumenta o contador de pacotes faltando
            fi
        fi
    done

    # Verifica quantos pacotes estão faltando, >= 1 avisa e encerra o script
    if [ "$erros" -ge 1 ];then
        echo ""
        echo "---------------------------"
        echo "Erro Crítico: Foram encontrados $erros pacotes faltando."
        echo "Instale-os e tente novamente."
        exit 1
    fi
}
# -------

       # Função que recebe i JSON e devolve apenas o valor
tratar_escolha(){
    # Variáveis locais
    local json="$1"
    echo "$json" | jq -r ".text"
}
# -------

       # Função das escolhas das opções de download
get_escolha(){
    # Variáveis locais
    local tipo
    local formato

    # Escolha do tipo de download
    tipo=$(termux-dialog radio -v "Vídeo e Áudio, Só Vídio, Só Áudio" -t "Selecione o Tipo de Download.")
    # troca o json pela palavra escolhida
    tipo=$(tratar_escolha "$tipo")

    # Escolha dos formatos dependendo da escolha anterior
    if [ "$tipo" == "Vídeo e Áudio" ]; then
        formato=$(termux-dialog radio -v "MP4, WebM, MKV")
    elif [ "$tipo" == "Só Vídio" ]; then
        formato=$(termux-dialog radio -v "MP4, WebM, MKV")
    else
        formato=$(termux-dialog radio -v "MP3, WebM, M4A")

    # Troca o json pela palavra
    formato=$(tratar_escolha "$formato")

    echo "${tipo}|${formato}" # Saida da função 
}

       # Função Principal
main(){
    # Variáveis locais
    local link="${1:-$(termux-clipboard-get)}"
    local tipo
    local formato

    # Limpa a tela
    clear
    echo "--- Downloader Termux ---"
    echo ""
    

    # Verifica dependencias
    verificar_dependecia

    # Escolha do tipo de download e do formato do video
    escolhas=$(get_escolha)

    # Separa os resultados
    tipo=$(echo "$escolhas" | cut -d"|" -f1)
    formato=$(echo "$escolhas" | cut -d"|" -f2)

    echo "Você escolheu o download de ${tipo}, no formato de ${formato}."

    read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
    echo ""


}

       # Execução Condicional
# Só roda a main se o script for executado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi