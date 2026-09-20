![eep0x10.github.io — Publicação estática e referências do projeto.](docs/assets/banner.svg)

# eep0x10.github.io

**Publicação estática e referências do projeto.**

[Estrutura editorial](#estrutura-editorial) · [Manutenção](#manutenção) · [Publicação e validação](#publicação-e-validação)

Repositório de publicação estática associado ao perfil `eep0x10`. A configuração versionada utiliza o tema **jekyll-theme-hacker**; a entrada de conteúdo é `index.md`.

## Estrutura editorial

| Arquivo | Responsabilidade |
| --- | --- |
| `_config.yml` | Tema e configuração do Jekyll. |
| `index.md` | Conteúdo da página de entrada. |
| `README.md` | Orientação para manutenção do repositório. |

## Manutenção

```sh
git clone https://github.com/eep0x10/eep0x10.github.io.git
cd eep0x10.github.io
git status
```

Revise o conteúdo da página e os arquivos que serão publicados antes de enviar alterações. A branch e a origem de publicação são definidas nas configurações do GitHub Pages; o nome do repositório, sozinho, não confirma uma implantação ativa.

## Publicação e validação

Não há `Gemfile`, script de build ou suíte de testes versionados para uma reprodução local completa. Para alterações editoriais, verifique Markdown, links, texto alternativo e visualização do GitHub. A validação do site publicado deve ocorrer após a revisão das configurações de Pages.

Arquivos na árvore podem ficar acessíveis conforme a configuração de publicação. Este guia não é um catálogo dos demais artefatos do repositório; revise o escopo público antes de adicionar novos arquivos. Não publique documentos pessoais, credenciais ou dados de terceiros.
