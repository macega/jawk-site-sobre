# jawk-site-sobre

> Portfólio e currículo do Juliano Alves Medina, servido em `https://jawk.com.br/` (domínio raiz da JAWK), sem anúncios.

## Informações gerais

| Item | Detalhe |
|---|---|
| Cliente | JAWK Digital Group |
| Status | Pronto para publicar |
| Linguagem / stack | HTML + CSS puro, servido por Nginx 1.27 (alpine) |
| IDE | VS Code |
| Banco de dados | Nenhum |
| Docker | Sim (`nginx:1.27-alpine`, porta 8001 no servidor, atualizado pelo Watchtower) |
| Repositório | https://github.com/macega/jawk-site-sobre |
| Último commit | 2026-11-11 |

## Objetivo

Substituir a página atual de `jawk.com.br` ("Ué...") por um site com conteúdo real. O AdSense analisa o
domínio cadastrado (`jawk.com.br`); com página vazia ou "em construção" a reprovação por
"conteúdo de pouco valor" é quase certa. A aprovação do domínio raiz vale também para `tradutor.jawk.com.br`.

Regras:

- **Sem anúncios neste site.** Propaganda no currículo passa má impressão a recrutadores e rende pouco.
  Os anúncios ficam no `tradutor.jawk.com.br` (projeto `jawk-tradutor-site`).
- Várias páginas com texto original, navegação funcionando e nada "em construção".
- Publicar o site **antes** de pedir a análise do AdSense.

## Páginas

- [x] Início = Sobre (`public/index.html`): foto, resumo, o que eu faço, cards dos projetos e contato
- [x] Currículo (`public/curriculo.html`): experiência, formação, certificações e idiomas, com CSS de impressão (Ctrl+P → Salvar como PDF)
- [x] Página de erro (`public/404.html`)
- [x] Uma página por projeto (`public/projetos/`): o problema, o que faz, como funciona por dentro e prints
  - [x] JAWK Tradutor (`/projetos/jawk-tradutor`, com link para `https://tradutor.jawk.com.br/`)
  - [x] Portaria Plus (`/projetos/portaria-plus`)
  - [x] JAWK Media Shrink (`/projetos/jawk-media-shrink`)
  - [x] Broadcast FTP Ingest, o MonitorFTP (`/projetos/broadcast-ftp-ingest`)
- [x] Link para a Política de Privacidade em `https://legal.jawk.com.br/` no rodapé de todas as páginas
- [x] `ads.txt` e meta `google-adsense-account` (sem nenhum script de anúncio)

Decisões:

- Só tema escuro, paleta preto + ciano + magenta (a mesma luz das fotos). HTML e CSS puro, sem JavaScript, sem analytics e sem banner de cookies.
- Repositórios dos projetos são privados: as páginas não têm link para o código.
- Trabalho de cliente entra só no currículo, sem página própria.
- Contato: `medina@jawk.com.br`, LinkedIn, GitHub, botão do WhatsApp (sem o número escrito) e Cacoal – RO. Endereço e telefone não aparecem.
- Prints com dado real (nomes de pessoas, IPs de servidor, nome de cliente, títulos de matérias) ficam fora do site.

## Imagens

- Prints em `public/img/projetos/<projeto>/*.webp` (até 1600 px de largura, WebP qualidade 82).
- Foto do perfil: `public/img/juliano.webp` (480×480) e `public/img/og-image.jpg` (1200×630, pré-visualização em redes sociais).
- Os originais (PNG das fotos e dos prints) ficam em `referencias/`, que está no `.gitignore` e no `.dockerignore`: não vão para o GitHub nem para a imagem Docker.
- Para trocar um print: tire a tela com dados fictícios, converta para WebP e atualize `width`/`height` no `<img>`.

## Como executar

### Teste local

```bash
docker build -t jawk-site-sobre:latest .
docker run --rm -p 8001:80 jawk-site-sobre:latest
# Acesse: http://localhost:8001
```

### Deploy no servidor

1. Push na `main` dispara o GitHub Actions (`.github/workflows/deploy.yml`), que publica
   `ghcr.io/macega/jawk-site-sobre:latest` no GitHub Container Registry (usa o `GITHUB_TOKEN`, sem secrets).
2. No servidor, o Watchtower (no `docker-compose.yml`) verifica a imagem a cada 60 s e recria o container
   quando ela muda.
3. Primeira vez, depois do primeiro build:
   - GitHub → **Packages** → `jawk-site-sobre` → **Package settings** → mudar a visibilidade para **Public**.
   - No servidor:
     ```bash
     mkdir -p ~/jawk-site-sobre && cd ~/jawk-site-sobre
     curl -fsSLO https://raw.githubusercontent.com/macega/jawk-site-sobre/main/docker-compose.yml
     docker compose up -d
     ```
4. No Nginx Proxy Manager, apontar `jawk.com.br` e `www.jawk.com.br` para a porta `8001`, com SSL do Let's Encrypt.

## Configuração

- Nenhum secret no GitHub: o workflow publica no ghcr.io com o `GITHUB_TOKEN` automático.
- `nginx.conf`: aceita URLs sem `.html` (`/curriculo` serve `curriculo.html`), redireciona `/projetos` para `/#projetos` e devolve 404 para página inexistente.
- Ao incluir uma página nova: atualizar `public/sitemap.xml`, o menu e o rodapé (repetidos em cada `.html`).
- `security-headers.inc`: headers de segurança, incluídos em cada `location` (um `add_header` dentro de
  `location` anula os do `server`).
- Arquivos sensíveis (`.env`, certificados, chaves) estão no `.gitignore` e não vão para o GitHub.

## Estrutura de pastas

```
public/                  páginas do site (copiadas para /usr/share/nginx/html)
  index.html             início (sobre)
  curriculo.html         currículo
  projetos/              uma página por projeto
  css/site.css           estilo único do site (inclui o CSS de impressão)
  img/                   foto, og-image e prints dos projetos
  ads.txt, robots.txt, sitemap.xml, favicon.svg, 404.html
referencias/             originais das fotos e prints (fora do Git e do Docker)
nginx.conf               config do Nginx
security-headers.inc     headers de segurança
Dockerfile               imagem nginx:1.27-alpine
docker-compose.yml       site (porta 8001) + Watchtower para atualização automática
.github/workflows/       build e deploy automático
```

## Observações

- Projetos relacionados: `jawk-legal` (legal.jawk.com.br), `jawk-tradutor-site` (tradutor.jawk.com.br).

## Histórico

| Data | Alteração |
|---|---|
| 2026-11-11 | Estrutura inicial e plano do site |
| 2026-11-11 | Docker (Nginx), compose e deploy via GitHub Actions + Portainer |
| 2026-11-11 | Deploy trocado para GHCR + Watchtower (sem Portainer e sem secrets) |
| 2026-11-11 | Site completo: início, currículo, 4 páginas de projeto, 404, ads.txt, sitemap |
