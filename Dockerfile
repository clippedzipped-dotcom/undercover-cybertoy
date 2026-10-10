FROM alpine:3.20 AS payload
RUN apk add --no-cache coreutils
WORKDIR /payload
COPY src/ /payload/
# src/p01.b64 + p02.b64 + p03.b64 = one gzipped base64 blob of index.html.
# Fail the build loudly if the payload does not decode cleanly.
RUN cat p01.b64 p02.b64 p03.b64 | tr -d '\n\r' | base64 -d | gunzip > index.html \
 && head -c 15 index.html | grep -q '<!DOCTYPE html>' \
 && wc -c index.html

FROM nginx:alpine

# Railway injects PORT; fall back to 8080 so nginx always has a listen directive.
ENV PORT=8080

# nginx:alpine renders /etc/nginx/templates/*.template with envsubst at startup,
# which is how ${PORT} reaches the listen directive.
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

COPY --from=payload /payload/index.html /usr/share/nginx/html/index.html

EXPOSE 8080