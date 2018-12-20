FROM debian:9.6-slim@sha256:f05c05a218b7a4a5fe979045b1c8e2a9ec3524e5611ebfdd0ef5b8040f9008fa

ARG librdkafka_version=v1.0.0-RC5
ARG yajl_version=2.1.0

COPY . /usr/src/kafkacat

RUN set -ex; \
  runtimeDeps='libssl1.1 libsasl2-2 jq'; \
  buildDeps='curl ca-certificates build-essential zlib1g-dev liblz4-dev libssl-dev libsasl2-dev python cmake'; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get install -y $runtimeDeps $buildDeps --no-install-recommends; \
  rm -rf /var/lib/apt/lists/*; \
  \
  cd /usr/src/kafkacat; \
  \
  sed -i "s|github_download \"edenhill/librdkafka\" \"master\"|github_download \"edenhill/librdkafka\" \"${librdkafka_version}\"|" ./bootstrap.sh; \
  sed -i "s|github_download \"lloyd/yajl\" \"master\"|github_download \"lloyd/yajl\" \"${yajl_version}\"|" ./bootstrap.sh; \
  \
  echo "Source versions:"; \
  grep ^github_download ./bootstrap.sh; \
  \
  ./bootstrap.sh; \
  mv ./kafkacat /usr/local/bin/; \
  \
  rm -rf /usr/src/kafkacat/tmp-bootstrap; \
  apt-get purge -y --auto-remove $buildDeps; \
  rm /var/log/dpkg.log /var/log/alternatives.log /var/log/apt/*.log; \
  \
  kafkacat -V

ENTRYPOINT ["kafkacat"]
