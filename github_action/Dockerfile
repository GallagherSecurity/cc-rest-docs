FROM uwebarthel/asciidoctor@sha256:f7bc59dcc37c563aa7cdcd2a6321e64119a547d156a37b0becb2635f08181c7e

RUN apk add --no-cache nodejs npm && npm install -g sourcey

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
