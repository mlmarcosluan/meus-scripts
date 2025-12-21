#!/data/data/com.termux/files/usr/bin/bash 

       # Verifica se o yt-dlp está instalado
verificar_dependecia(){
    
    dependencias="yt-dlp termux-clipboard-get" # Usei o termux-clipboard para verificar se o termux-api está instalado
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

       # Função Principal
main(){
    # Variáveis locais
    local link="${1:-$(termux-clipboard-get)}"
    # Limpa a tela
    clear
    echo "--- Downloader Termux ---"
    echo ""
    echo "$link"

    # Verifica dependencias
    verificar_dependecia

    read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
    echo ""


}

       # Execução Condicional
# Só roda a main se o script for executado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi