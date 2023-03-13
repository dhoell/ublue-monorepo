ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM scratch

COPY --from=ghcr.io/dhoell/ublue-akmod-v4l2loopback:${FEDORA_MAJOR_VERSION} /var/cache /var/cache
COPY --from=ghcr.io/dhoell/ublue-akmod-v4l2loopback:${FEDORA_MAJOR_VERSION} /tmp/ublue-os /tmp/ublue-os

#other akmods go here
