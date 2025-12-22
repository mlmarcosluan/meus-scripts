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
                termux-dialog confirm -t "Erro de Dependência" -i "O termux-api não está instalado."
                ((erros++)) # Aumenta o contador de pacotes faltando
            else
                termux-dialog confirm -t "Erro de Dependência" -i "O $pacote não está instalado"
                ((erros++)) # Aumenta o contador de pacotes faltando
            fi
        fi
    done

    # Verifica quantos pacotes estão faltando, >= 1 avisa e encerra o script
    if [ "$erros" -ge 1 ];then
        termux-dialog confirm -t "Erro de Dependência" -i "$erros pacotes não instalado(s)."
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
    local resolucao
    local altura

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
    fi

    # Troca o json pela palavra
    formato=$(tratar_escolha "$formato")

    # Escolha da resolução do vídeo
    if [ "$tipo" != "Só Áudio" ]; then # Ou seja vamos baixar Vídeo
        resolucao=$(termux-dialog radio -v "Melhor Disponível,2160p (4K),1440p (2K),1080p,720p,480p,360p" -t "Selecione a Resolução do Vídeo.")
        resolucao=$(tratar_escolha "$resolucao") # Converte o json em uma frase/palavra

        # Converter texto para número (altura) para o yt-dlp
        case "$resolucao" in
            "2160p (4K)") altura="2160" ;;
            "1440p (2K)") altura="1440" ;;
            "1080p")      altura="1080" ;;
            "720p")       altura="720" ;;
            "480p")       altura="480" ;;
            "360p")       altura="360" ;;
            *)            altura="" ;; # Melhor Disponível
        esac
    fi

    echo "${tipo}|${formato}|${altura}" # Saida da função 
}

# -------

       # Função que constroi o comando do download
argumetos_cmd(){
    local tipo="$1"
    local formato="$2"
    local altura="$3"
    local cmd

    if [ "$tipo" == "Só Áudio" ]; then
        cmd="yt-dlp -x --audio-format $formato"
    elif [ "$tipo" == "Só Vídeo" ]; then
        if [ -n "$altura" ]; then # Resolução de video escolhida
            cmd="yt-dlp -f \"bestvideo[height<=${altura}]\" --remux-video $formato"
        else
            cmd="yt-dlp -f \"bestvideo\" --remux-video $formato"
        fi
    else # Video e Áudio
        if [ -n "$altura" ]; then # Altura definida
            cmd="yt-dlp -f bestvideo[height<=${altura}]+bestaudio/best[height<=${altura}] --merge-output-format $formato"
        else
            cmd="yt-dlp -f bestvideo+bestaudio/best --merge-output-format $formato"
        fi
    fi

    echo "$cmd -o \"/sdcard/Download/%(title)s.%(ext)s\""
}

# ------

       # Função Principal
main(){
    # Variáveis locais
    local link="${1:-$(termux-clipboard-get)}"
    local tipo
    local formato
    local altura

    # Limpa a tela
    clear
    
    # Verifica dependencias
    verificar_dependecia

    # Escolha do tipo de download e do formato do video
    escolhas=$(get_escolha)

    # Separa os resultados
    tipo=$(echo "$escolhas" | cut -d"|" -f1)
    formato=$(echo "$escolhas" | cut -d"|" -f2)
    altura=$(echo "$escolhas" | cut -d"|" -f3)

    # Construir comando
    cmd=$(argumetos_cmd tipo formato altura)

    # Iniciar download
    eval $cmd --no-mtime \"link\"

    # Captura o código de download
    

    echo "Caso o download não começar verifique se o termux tem acesso aos arquivos."
    read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
    echo ""


}

       # Execução Condicional
# Só roda a main se o script for executado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi