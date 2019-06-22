FROM alpine:3.10@sha256:ca1c944a4f8486a153024d9965aafbe24f5723c1d5c02f4964c045a16d19dc54

RUN apk add --no-cache curl ca-certificates jq snappy zstd

RUN set -e; \
  curl -sLS -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
  curl -sLS -o kafkacat.apk https://github.com/sgerrand/alpine-pkg-kafkacat/releases/download/1.4.0-r0/kafkacat-1.4.0-r0.apk; \
  apk add --no-cache kafkacat.apk; \
  rm kafkacat.apk

ENTRYPOINT [ "/usr/bin/kafkacat" ]
