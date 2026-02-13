FROM alpine:latest

COPY files /

RUN set -xe && \
    apk add --no-cache bash curl && \
    chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
