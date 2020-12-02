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
| Criador                      | [ChefByzen](https://www.hackthebox.eu/home/users/profile/140851) |


> Sistema Usado: Windows 10 + WSL2 Ubuntu

## Hosts
Adicionar o ip e o domínio no arquivos "hosts" 

Windows: `C:\Windows\System32\drivers\etc\hosts`

Linux: `/etc/hosts`

> É necessário **admin** / **root** para editar o arquivo

```
10.10.10.206	passage.htb
```

> **Dica**: Em windows pode-se usar o ***notepad++*** para editar esse arquivo, pois o mesmo consegue salvar / editar com permissões administrativas. Enquanto em linux, é necessário editar o arquivo com **sudo** nano /etc/hosts .


## Scan
Ferramenta usada: [Rustscan](https://github.com/RustScan/RustScan)
```terminal
$ rustscan 10.10.10.206 -- -Pn -sV
```
Resultado 1 : Varrimento de todas as portas
```terminal
Open 10.10.10.206:22
Open 10.10.10.206:80
```
Resultado 2 : Nmap nas portas abertas
```terminal
PORT   STATE SERVICE REASON  VERSION
22/tcp open  ssh     syn-ack OpenSSH 7.2p2 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    syn-ack Apache httpd 2.4.18 ((Ubuntu))
```

> O **rustscan** é usado com a função de ***varrer todas as portas de um host rapidamente***, e em seguida, **ele mesmo executa o nmap**, utilizando os parâmetros definidos após o "**--**", realizando nesse caso um Service / Version Scan (-sV) nas portas abertas.

## Enumeração

Acessar a url do laboratório na porta 80
http://passage.htb

