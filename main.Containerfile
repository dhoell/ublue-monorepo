ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"
ARG IMAGE_NAME="${IMAGE_NAME}"
ARG AKMODS_CACHE="ghcr.io/dhoell/ublue-akmods"
ARG AKMODS_VERSION="${FEDORA_MAJOR_VERSION}"

COPY --from=${AKMODS_CACHE}:${AKMODS_VERSION}-525 / .

ADD install-main.sh /tmp/install-main.sh
ADD install-akmods.sh /tmp/install-akmods.sh
ADD post-install-main.sh /tmp/post-install-main.sh
ADD packages.json /tmp/packages.json

COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms

RUN /tmp/install-main.sh
RUN /tmp/install-akmods.sh
RUN /tmp/post-install-main.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
