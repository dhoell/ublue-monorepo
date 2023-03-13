ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="ghcr.io/dhoell/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"
ARG AKMOD_V4L2LOOPBACK="ghcr.io/dhoell/ublue-akmod-v4l2loopback"
ARG AKMODS_VERSION="${FEDORA_MAJOR_VERSION}"

COPY --from=${AKMOD_V4L2LOOPBACK}:${AKMODS_VERSION} / .

ADD extended-install.sh /tmp/extended-install.sh

RUN /tmp/extended-install.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
