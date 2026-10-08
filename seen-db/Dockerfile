ARG BUILD_FROM=couchdb:3.5.2
FROM ${BUILD_FROM}
ARG BUILD_ARCH=amd64
ARG TS_VERSION=1.104.1
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl jq; \
    rm -rf /var/lib/apt/lists/*; \
    case "${BUILD_ARCH}" in aarch64) a=arm64 ;; *) a=amd64 ;; esac; \
    curl -fsSL "https://pkgs.tailscale.com/stable/tailscale_${TS_VERSION}_${a}.tgz" | tar xz -C /tmp; \
    mv /tmp/tailscale_*/tailscale /tmp/tailscale_*/tailscaled /usr/local/bin/; \
    rm -rf /tmp/tailscale_*
COPY seen.ini /opt/couchdb/etc/local.d/10-seen.ini
COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
