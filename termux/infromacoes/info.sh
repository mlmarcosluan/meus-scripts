#!/data/data/com.termux/files/usr/bin/bash

        # Função principal
main(){

}

# -------

       # Execução Condicional
# Só roda a main se o script for executado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi