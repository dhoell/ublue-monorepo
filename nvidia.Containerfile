ARG IMAGE_NAME=silverblue
ARG BASE_IMAGE=ghcr.io/dhoell/${IMAGE_NAME}-main
ARG FEDORA_MAJOR_VERSION=37

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG AKMODS_CACHE="ghcr.io/dhoell/ublue-akmods"
ARG AKMODS_VERSION="37"
ARG NVIDIA_MAJOR_VERSION="525"

COPY --from=${AKMODS_CACHE}:${AKMODS_VERSION}-${NVIDIA_MAJOR_VERSION} / .

COPY install-nvidia.sh /tmp/install-nvidia.sh
COPY post-install-nvidia.sh /tmp/post-install-nvidia.sh
RUN /tmp/install-nvidia.sh
RUN /tmp/post-install-nvidia.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /tmp /var/tmp
