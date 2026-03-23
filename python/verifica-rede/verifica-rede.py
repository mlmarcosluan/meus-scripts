#!/usr/bin/env python3
import sys #
import ipaddress
from scapy import ARP


def main():
    """Função principal, onde o script começa"""
    pass

if __name__ == "__main__":
    try: # Adicionado um try/except para caso o script seja interrompido não tenha mensagem de erros
        main()
    except KeyboardInterrupt:
        print("\n[!] Saindo...")
        sys.exit(0)