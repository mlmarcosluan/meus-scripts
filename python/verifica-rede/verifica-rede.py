#!/usr/bin/env python3
"""
Scanner de Rede Local
Autor: Marcos Luan
Data: 2026
"""

import sys # Fornece acesso a variáveis e funções do sistema
import ipaddress # Biblioteca para validar, manipular e iterar sobre endereços de rede e sub-redes
from scapy.all import ARP, Ether, srp # Importa classes para criar pacotes ARP, frames Ethernet e a função de envio/recebimento em Camada 2
import socket  # Biblioteca para lidar com conexões de rede de baixo nível

def ip_rede():
    """
    Descobre o endereço IP da rede atual
    """

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # AF_INET: Usaremos protocolo IPv4, SOCK_DGRAM: Usaremos UDP (sem conexão completa)
    try:
        s.connect(("8.8.8.8", 1)) # Conexão "falsa" com DNS do google apenas para as informações
        ip = s.getsockname()[0] # Pega o ip da rede
    except Exception: # Caso offline
        ip = "127.0.0.1"
    finally: # Idependente do resutado acima ele encerra a conexão
        s.close()

    return ip # Retorna ip

def main():
    """Função principal, onde o script começa"""
    pass

if __name__ == "__main__":
    try: # Adicionado um try/except para caso o script seja interrompido não tenha mensagem de erros
        main()
    except KeyboardInterrupt:
        print("\n[!] Saindo...")
        sys.exit(0)