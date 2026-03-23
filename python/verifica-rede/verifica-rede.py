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
    Descobre o endereço IP da rede atual, calcula a sub-rede /24 e já retorna o objeto válido
    pelo ipaddress
    """
    # 1. Descobre o IP
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # AF_INET: Usaremos protocolo IPv4, SOCK_DGRAM: Usaremos UDP (sem conexão completa)
    try:
        s.connect(("8.8.8.8", 1)) # Conexão "falsa" com DNS do google apenas para as informações
        ip = s.getsockname()[0] # Pega o ip da rede
    except Exception: # Caso offline
        ip = "127.0.0.1"
    finally: # Idependente do resutado acima ele encerra a conexão
        s.close()

    # 2. Transforma IP (ex.: 192.168.1.15 -> 192.168.1.0/24)
    rede_str = ip.rsplit(".", 1)[0] + ".0/24"

    # 3. Válida a rede com o ipaddress
    rede = ipaddress.ip_network(rede_str, strict=False)

    return rede # Retorna um objeto IPv4Network

def scanear(rede_alvo):
    """
    Escaneia a rede_alvo e retorna uma lista de ips de dispositivos conectados a rede
    """
    # 0. Converte a rede_alvo em texto puro
    alvo_str = str(rede_alvo)

    # 1. Cria o pacote com a camada fisica "sobre" a lógica
    pacote = Ether(dst="ff:ff:ff:ff:ff:ff") / ARP(pdst=alvo_str)

    # 2. Envia e recebe o pacote (timeout de 5 segundos)
    respondidos, nao_respondidos = srp(pacote, timeout=5, verbose=False)

    # 3. Extrai os dados dos pacotes recebidos diretamenta das variáveis internas do scapy e salva os em um dicionário
    mapeamento_rede = {} # Dicionário vazio onde será adicionado os ip e macs
    for pacote_enviado, pacote_recebido in respondidos:
        ip_encontrado = pacote_recebido.psrc
        mac_encontrado = pacote_recebido.hwsrc

        # Adiciona ao dicionário
        mapeamento_rede[ip_encontrado] = mac_encontrado
    
    return mapeamento_rede
        

def main():
    """Função principal, onde o script começa"""
    # Define a rede a ser análisada
    rede = ip_rede()
    mapeamento_rede = scanear(rede)

    

if __name__ == "__main__":
    try: # Adicionado um try/except para caso o script seja interrompido não tenha mensagem de erros
        main()
    except KeyboardInterrupt:
        print("\n[!] Saindo...")
        sys.exit(0)