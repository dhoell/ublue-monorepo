ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG BASE_IMAGE="ghcr.io/dhoell/${IMAGE_NAME}-extended"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG AKMODS_NVIDIA="ghcr.io/dhoell/ublue-akmod-nvidia"
ARG AKMODS_VERSION="${FEDORA_MAJOR_VERSION:-37}"
ARG NVIDIA_MAJOR_VERSION="${NVIDIA_MAJOR_VERSION}"

COPY --from=${AKMODS_NVIDIA}:${AKMODS_VERSION}-${NVIDIA_MAJOR_VERSION} / .

COPY nvidia-install.sh /tmp/nvidia-install.sh
COPY nvidia-post-install.sh /tmp/nvidia-post-install.sh
RUN /tmp/nvidia-install.sh
RUN /tmp/nvidia-post-install.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /tmp /var/tmp
