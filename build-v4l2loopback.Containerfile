#Build from ublue/base, simpley because it's the smallest image
ARG IMAGE_NAME="${IMAGE_NAME:-base}"
ARG BASE_IMAGE="ghcr.io/dhoell/${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

COPY --from=ghcr.io/ublue-os/config:latest /build /tmp/build
COPY justfile /tmp/build/ublue-os-just/justfile
COPY build.sh /tmp/build.sh

ADD certs /tmp/certs

RUN /tmp/build-v4l2loopback.sh

FROM scratch

COPY --from=builder /var/cache /var/cache
COPY --from=builder /tmp/ublue-os /tmp/ublue-os
