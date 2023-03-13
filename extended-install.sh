#!/bin/sh

set -ouex pipefail

#source akmod variables
source /var/cache/akmods/akmod-v4l2loopback-vars

#install local kmod RPMs and possible necessary remote packages
rpm-ostree install \
    v4l2loopback \
    /var/cache/akmods/v4l2loopback/kmod-v4l2loopback-${KERNEL_VERSION}-${LOOPBACK_AKMOD_VERSION}.fc${RELEASE}.rpm
