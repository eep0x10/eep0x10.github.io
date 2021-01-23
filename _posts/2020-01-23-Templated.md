# Templated

---
title: 【HTB】Challenge Templated (pt-br)
published: true
author: EEP0x10
date: '2021-01-23'
categories:
  - SecInfo
tags:
  - htb
  - Challenge
---

Ao acessar a aplicação via browser, é retornado a seguinte tela.

!(00)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/df470e04-f148-4a32-ba2f-76dddd47d145/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031932Z&X-Amz-Expires=86400&X-Amz-Signature=b6fff8c8eee49f7b1f364ecb673ef6557fdd32ae43aae5f71b61a35b63e8531b&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/df470e04-f148-4a32-ba2f-76dddd47d145/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031932Z&X-Amz-Expires=86400&X-Amz-Signature=b6fff8c8eee49f7b1f364ecb673ef6557fdd32ae43aae5f71b61a35b63e8531b&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

Ao tentar acessar outra páginas, é retornado o seguinte erro.

!(000)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/078f5c46-27d3-4dfd-a92f-47ace902c6d1/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031934Z&X-Amz-Expires=86400&X-Amz-Signature=1342e19696aaee8bea652ae4f574b5ab56a5d9fc906d69ca8cfc264f087911f9&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/078f5c46-27d3-4dfd-a92f-47ace902c6d1/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031934Z&X-Amz-Expires=86400&X-Amz-Signature=1342e19696aaee8bea652ae4f574b5ab56a5d9fc906d69ca8cfc264f087911f9&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

Por conta do erro retornado, e da informação na página inicial a respeito da tecnologia usada (Jinja2), é possível deduzir que a vulnerabilidade referente ao desafio se trata da SSTI (Server Side Template Injection)

> Jinja2 é uma template engine, escrito em python presente no micro-framework web Flask.      (*mais informações*)[[https://www.treinaweb.com.br/blog/o-que-e-o-jinja2/](https://www.treinaweb.com.br/blog/o-que-e-o-jinja2/)]

Para validar se a aplicação web é vulnerável a SSTI, é necessário informar uma conta matemática e verificar se ao renderizar é retornado o resultado.

!(01)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/1509631d-66d0-41d8-a5f5-6cdbb7535b50/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031641Z&X-Amz-Expires=86400&X-Amz-Signature=c4b6c62d750b3f91330fe57e02b9343044128345c0b1f905069297d7e6410534&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/1509631d-66d0-41d8-a5f5-6cdbb7535b50/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031641Z&X-Amz-Expires=86400&X-Amz-Signature=c4b6c62d750b3f91330fe57e02b9343044128345c0b1f905069297d7e6410534&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

Por se tratar de um site feito em Jinja2, basta validar se o payload {{7*7}} retorna o resultado 49.

!(02)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/4ad33801-8d3b-4b35-af51-f8b26c6a3b9e/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031645Z&X-Amz-Expires=86400&X-Amz-Signature=f09a5e727d86a6fda4bba24b345d9e321598cabb9d81dd2663aae715fdcaeb1b&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/4ad33801-8d3b-4b35-af51-f8b26c6a3b9e/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031645Z&X-Amz-Expires=86400&X-Amz-Signature=f09a5e727d86a6fda4bba24b345d9e321598cabb9d81dd2663aae715fdcaeb1b&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

!(IMG)[[https://apapedulimu.click/wp-content/uploads/2019/06/meme-is-this-680x510.png](https://apapedulimu.click/wp-content/uploads/2019/06/meme-is-this-680x510.png)]

# SSTI to RCE

Após validar que a aplicação é vulnerável, basta usar o payload correto referente a engine usada na aplicação para conseguir o RCE

(SSTI Jinja2)[[https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/](https://www.onsecurity.io/blog/server-side-template-injection-with-jinja2/)]

Payload Usado: `{{request.application.**globals**.**builtins**.**import**('os').popen('id').read()}}`

!(03)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/2095fd0b-81ae-4057-94c7-3baacefb116e/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031647Z&X-Amz-Expires=86400&X-Amz-Signature=20a4e712291ccfc84ff41b876839d448506fa120c4cdc9094d64e43ecfd5a04e&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/2095fd0b-81ae-4057-94c7-3baacefb116e/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031647Z&X-Amz-Expires=86400&X-Amz-Signature=20a4e712291ccfc84ff41b876839d448506fa120c4cdc9094d64e43ecfd5a04e&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

!(04)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/85df6ea5-f109-454c-bfe3-05b4b968d612/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031649Z&X-Amz-Expires=86400&X-Amz-Signature=2603e89406b40c3e3ac7722afe81c9372bd94095aeeaa3ef95b505208083d49d&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/85df6ea5-f109-454c-bfe3-05b4b968d612/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031649Z&X-Amz-Expires=86400&X-Amz-Signature=2603e89406b40c3e3ac7722afe81c9372bd94095aeeaa3ef95b505208083d49d&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

para executar comandos com espaço (ls -la), é necessário encodar para URL

!(05)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/63f789b9-65e4-47b8-b8e0-35d4aa79426a/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031652Z&X-Amz-Expires=86400&X-Amz-Signature=f675629b352db668523da5bf1154027f178159da7803c102df8624cdc86976ff&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/63f789b9-65e4-47b8-b8e0-35d4aa79426a/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031652Z&X-Amz-Expires=86400&X-Amz-Signature=f675629b352db668523da5bf1154027f178159da7803c102df8624cdc86976ff&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

!(06)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/b1d08621-d617-4cef-9407-9fb9a89ff850/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031653Z&X-Amz-Expires=86400&X-Amz-Signature=ec762b7d0f513b3f983104cc55127aeb104e1ffd8d49b77cf7ff2f878b85ef9b&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/b1d08621-d617-4cef-9407-9fb9a89ff850/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031653Z&X-Amz-Expires=86400&X-Amz-Signature=ec762b7d0f513b3f983104cc55127aeb104e1ffd8d49b77cf7ff2f878b85ef9b&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

# flag.txt

!(07)[[https://s3.us-west-2.amazonaws.com/secure.notion-static.com/5023ae8b-c257-4c68-9e6c-301c5abd4bdd/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031655Z&X-Amz-Expires=86400&X-Amz-Signature=bd6b12a5a848092fd752c3714154ecd21ae0f1900568449314505a91baf9dacb&X-Amz-SignedHeaders=host&response-content-disposition=filename %3D"Untitled.png"](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/5023ae8b-c257-4c68-9e6c-301c5abd4bdd/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T031655Z&X-Amz-Expires=86400&X-Amz-Signature=bd6b12a5a848092fd752c3714154ecd21ae0f1900568449314505a91baf9dacb&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)]

<br>

Flag capturada!

!(FLAG)[[https://i.ytimg.com/vi/7f94Z--PJdc/hqdefault.jpg](https://i.ytimg.com/vi/7f94Z--PJdc/hqdefault.jpg)]