#!/bin/bash

main(){
    local dependencias
    local -a pacotes_falt=()

    dependencias=""

    # Verifica se cada pacote necessário está instalado
    for pacote in $dependencias; do
        if ! command -v "$pacote" &> /dev/null; then
            pacotes_falt+=("$pacote")
        fi
    done

    # Verifica se exite algum pacote faltando
    if [ ${#pacotes_falt[@]} -gt 0 ]; then
        # Coloque aqui o que fazer caso haja alguma dependência faltando
        exit 1
    fi
}

# If necessário para importar o script sem rodar nada
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi