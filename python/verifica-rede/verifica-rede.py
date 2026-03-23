#!/usr/bin/env python3
"""
Scanner de Rede Local
Autor: Marcos Luan
Data: 2026
"""

import sys # Fornece acesso a variáveis e funções do sistema
import ipaddress # Biblioteca para validar, manipular e iterar sobre endereços de rede e sub-redes
from scapy.all import ARP, Ether, srp # Importa classes para criar pacotes ARP, frames Ethernet e a função de envio/recebimento em Camada 2


def main():
    """Função principal, onde o script começa"""
    pass

if __name__ == "__main__":
    try: # Adicionado um try/except para caso o script seja interrompido não tenha mensagem de erros
        main()
    except KeyboardInterrupt:
        print("\n[!] Saindo...")
        sys.exit(0)