#!/bin/sh

set -ouex pipefail

source /var/cache/akmods/akmod-vars

rpm-ostree install \
    v4l2loopback \
    /var/cache/akmods/v4l2loopback/kmod-v4l2loopback-${KERNEL_VERSION}-${LOOPBACK_AKMOD_VERSION}.fc${RELEASE}.rpm
