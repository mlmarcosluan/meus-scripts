#!/usr/bin/env python3

import subprocess # Para rodar comandos no termux
import json # Para trabalhar com arquivos/informações .json
import sys # Para fechar o script corretamente

def obter_notificacoes():
    """
    Usa a biblioteca subprocess para executar comando no termux que retorna um json
    com as notificações atuais do android
    """

    # 1. Executa o comando e captura a saída
    resultado = subprocess.run(
        ["termux-notification-list"],
        capture_output=True,
        text=True
    )

    # 2. Verifica se o comando rodou sem erros
    if resultado.returncode != 0: # Código de erro é diferente de 0
        print("Erro ao acessar notificações.")
        return []

    # 3. Converte o texto json que retornou em lista de dicionário
    try:
        notificacoes = json.loads(resultado.stdout)
        return notificacoes

    except json.JSONDecodeError: # Corrigido para JSONDecodeError
        print("Erro ao decodificar o JSON.")
        return []

def main():
    """
    Função principal
    """

    notificacoes = obter_notificacoes()

    print(notificacoes)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n[!] Saindo...")
        sys.exit(0)