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
#User Flag

# Buff | Hack the box

# Host
## <http://buff.htb:8080>

# IP: 10.10.10.198

# Infos
>Windows

# Ports
-----------------------------------------
|  PORT  | STATE |  SERVICE |  VERSION  |
-----------------------------------------
> 8080/tcp open  http-proxy

# Dirétórios
>000000046:   301        9 L      30 W     333 Ch     "img"
000000107:   301        9 L      30 W     336 Ch      "upload"
000000225:   403        45 L     113 W    1199 Ch     "phpmyadmin"
000000969:   301        9 L      30 W     337 Ch      "profile"
000001128:   301        9 L      30 W     332 Ch      "ex"
000001247:   200        338 L    2953 W   18025 Ch    "license"
000003222:   403        42 L     97 W     1040 Ch     "www.pl"
000004296:   301        9 L      30 W     333 Ch      "att"
000006157:   403        42 L     97 W     1040 Ch     "con"
000006931:   403        42 L     97 W     1040 Ch     "webalizer"
000009543:   200        133 L    308 W    4969 Ch     "#www"
000010595:   200        133 L    308 W    4969 Ch     "#mail"
000023036:   301        9 L      30 W     334 Ch      "boot"
000023228:   403        42 L     97 W     1040 Ch     "www.asp"
000024844:   301        9 L      30 W     337 Ch      "include"
000047764:   200        133 L    308 W    4969 Ch     "#smtp"

# Tecnologias
## Gym Management Software 1.0 

# Users 
> 
> \User\shaun

# Credentials
> 

##Username: root
##Password: ???

# Vulns
> RCE no framwork Gym Management Software 1.0
--------------------------------------------------------------
# Process

## Enumeração
1. Enumerar diretórios: /upload
2. Descobrir tecnologia usada: Gym Management Software 1.0 

## Exploitation
3. Procurar exploit
-------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                        |  Path
-------------------------------------------------------------------------------------- ---------------------------------
Gym Management System 1.0 - Unauthenticated Remote Code Execution                     | php/webapps/48506.py

4. Usar exploit RCE: <python2 /opt/exploitdb/exploits/php/webapps/48506.py http://buff.htb:8080/>
5. Navegar pelos diretórios e pegar a flag de user: /User/shaun/Desktop/user.txt

##Post-Exploitation
6. Escalar privilégio
	6. -> ir para phpmyadmin e pegar as infos**

# Flags
## User: 2c815f687a999f47a7e23124ec141c02
## Root: 

# Links Úteis
>