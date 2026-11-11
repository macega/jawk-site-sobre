# Estágio único: Nginx servindo os arquivos estáticos de public/
FROM nginx:1.27-alpine

# Troca a config padrão do Nginx pela do projeto
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY security-headers.inc /etc/nginx/conf.d/security-headers.inc

# Copia o site
COPY public/ /usr/share/nginx/html/
RUN rm -f /usr/share/nginx/html/.gitkeep

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
