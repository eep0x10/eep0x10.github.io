---
published: true
author: EEP0x10
date: '2020-11-04'
categories:
  - SecInfo
  - Writeup
tags:
  - Writeup
  - HTB
---
![Logo](https://www.hackthebox.eu/storage/avatars/ec88bbe570fd512ab370208e5139bb41.png){: width="240" class="right"}
## Informações

|:-----------------------------|:-------------|
| Sistema Operacional          | Linux        |
| Dificuldade                  | Médio        |
| Pontos                       | 30           |
| Lançamento                   | 05/09/2020   | 
| IP                           | 10.10.10.206 |

## Scan
[Rustscan](https://github.com/RustScan/RustScan)
```terminal
rustscan 10.10.10.206 -- -Pn -sV
```
Resultado 1 : Rustscan
```terminal
Open 10.10.10.206:22
Open 10.10.10.206:80
```
Resultado 2 : Nmap
```terminal
PORT   STATE SERVICE REASON  VERSION
22/tcp open  ssh     syn-ack OpenSSH 7.2p2 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    syn-ack Apache httpd 2.4.18 ((Ubuntu))
```
```
Rustscan é utilizado com a função de varrer todas as portas de um host rapidamente, e em seguida, ele mesmo executada o nmap, utilizando os parâmetros definidos após o "--", realizando nesse caso um Service / Version Scan (-sV) nas portas abertas.
```
## Enumeração
