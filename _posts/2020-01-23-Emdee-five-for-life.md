---
title: 【HTB】Challenge Emdee five for life (pt-br)
published: true
author: EEP0x10
date: '2021-01-23'
categories:
  - SecInfo
tags:
  - htb
  - Challenge
---

## Informações

|:-----------------------------|:-------------|
| Dificuldade                  | Fácil         |
| Pontos                       | 20            |
| Lançamento                   | 23/10/2020   | 
| Criador                      | [L4mpje](https://www.hackthebox.eu/home/users/profile/29267) |

Ao acessar a aplicação via browser, é retornado a seguinte tela.

![page](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/118988a4-52af-4aa2-bca6-77662f806b68/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210123%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210123T223324Z&X-Amz-Expires=86400&X-Amz-Signature=726139f9bd8ecad21f419bdf62c38b27584e073ff6e280721bcf19cdde364fdd&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

O laboratório informa que o desafio é criptografar o hash MD5 informado e submeter rápido.

# flag.txt

A única maneira de fazer esse processo rápido, é por meio de um script: (no caso foi feito em python)

<br>

```python
import requests # Lib para enviar requisições 
import hashlib # Lib para converter strings para algum hash

r = requests.session() # Cria a sessão das requests

url = "http://IP:PORT/" # Define o ip do Laboratório
palavra="" # Variável da palavra 

for i in range(1):# Faz o processo 2 vezes, pois na primeira vez, as vezes não retorna a flag

	# Primeiro GET para obter a string
	out = r.get(url) 
	
	# Pega a string dentro do retorno do GET 
	for i in range(167,187): # (No caso ela está na posição 167 com 20 caracteres (167->187))
	    palavra+=out.text[i] 
	
	# MD5 
	str = hashlib.md5(palavra.encode('utf-8')) # Encoda a palavra para UTF-8 e para hash MD5
	text_hashed = str.hexdigest() # Armazena o Digest (Resultado final)
	print(palavra+" : "+text_hashed) # Imprime a string e o hash
	
	# Envia o POST com payload do hash
	payload = {'hash':text_hashed} # Cria o parâmetro que será enviado junto da requisição
	out = r.post(url = url,data = payload) # Envia o POST, definindo a URL do lab e o payload

print(out.text) # Imprime o retorno com a flag
```

<br>
## Flag capturada!
![https://i.ytimg.com/vi/7f94Z--PJdc/hqdefault.jpg](https://i.ytimg.com/vi/7f94Z--PJdc/hqdefault.jpg)
