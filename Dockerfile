FROM nginx:alpine

# Railway injects PORT; fall back to 8080 so nginx always has a listen directive.
ENV PORT=8080

# nginx:alpine renders /etc/nginx/templates/*.template with envsubst at startup,
# which is how ${PORT} reaches the listen directive.
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080
