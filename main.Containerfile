#Name of the spin. E.g. "Silverblue". Identical to SOURCE_IMAGE, except for lxqt and mate, which get build from "base" (due to lack of upstream image)
ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
#Name of the upstream image
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

ADD main-install.sh /tmp/main-install.sh
ADD main-post-install.sh /tmp/main-post-install.sh
ADD packages.json /tmp/packages.json

COPY --from=ghcr.io/ublue-os/config:latest /rpms /tmp/rpms
COPY --from=ghcr.io/ublue-os/config:latest /build /tmp/build

RUN /tmp/main-install.sh
RUN /tmp/main-post-install.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
