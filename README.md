# jawk-site-sobre

> Portfólio e currículo do Juliano Alves Medina, servido em `https://jawk.com.br/` (domínio raiz da JAWK), sem anúncios.

## Informações gerais

| Item | Detalhe |
|---|---|
| Cliente | JAWK Digital Group |
| Status | Em criação |
| Linguagem / stack | HTML + CSS puro, servido por Nginx 1.27 (alpine) |
| IDE | VS Code |
| Banco de dados | Nenhum |
| Docker | Sim (`nginx:1.27-alpine`, porta 8001 no servidor, atualizado pelo Watchtower) |
| Repositório | https://github.com/macega/jawk-site-sobre |
| Último commit | _(preencher)_ |

## Objetivo

Substituir a página atual de `jawk.com.br` ("Ué...") por um site com conteúdo real. O AdSense analisa o
domínio cadastrado (`jawk.com.br`); com página vazia ou "em construção" a reprovação por
"conteúdo de pouco valor" é quase certa. A aprovação do domínio raiz vale também para `tradutor.jawk.com.br`.

Regras:

- **Sem anúncios neste site.** Propaganda no currículo passa má impressão a recrutadores e rende pouco.
  Os anúncios ficam no `tradutor.jawk.com.br` (projeto `jawk-tradutor-site`).
- Várias páginas com texto original, navegação funcionando e nada "em construção".
- Publicar o site **antes** de pedir a análise do AdSense.

## Páginas planejadas

- [ ] Início (`public/index.html`) — apresentação e lista de projetos
- [ ] Sobre (`public/sobre.html`) — currículo
- [ ] Página de erro (`public/404.html`)
- [ ] Uma página por projeto: o que faz, tecnologia usada, prints e link para o site
  - [ ] JAWK Tradutor (`https://tradutor.jawk.com.br/`)
  - [ ] Portaria Plus
  - [ ] _(outros)_
- [ ] Link para a Política de Privacidade em `https://legal.jawk.com.br/`

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
- `nginx.conf`: aceita URLs sem `.html` (`/sobre` serve `sobre.html`) e devolve 404 para página inexistente.
- `security-headers.inc`: headers de segurança, incluídos em cada `location` (um `add_header` dentro de
  `location` anula os do `server`).
- Arquivos sensíveis (`.env`, certificados, chaves) estão no `.gitignore` e não vão para o GitHub.

## Estrutura de pastas

```
public/                  páginas do site (copiadas para /usr/share/nginx/html)
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
