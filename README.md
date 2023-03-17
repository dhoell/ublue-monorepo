# Main

[![build-ublue](https://github.com/ublue-os/main/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build.yml)

A WIP common main image for all other Ublue images.

1. [Features](#Features)
1. [Tips and Tricks](#Tips-and-Tricks)
1. [How to Install](#How-to-Install)
1. [Post Installation](#Post-Installation)
1. [Verification](#Verification)
1. [Configuring Automatic Updates](#Configuring-Automatic-Updates)
1. [Making your own](#Making-your-own)

## What is this?

You should be familiar with [immutable desktops](https://silverblue.fedoraproject.org/about). These are Fedora-ostree images that include a lot of quality-of-life features. We build 3 variants: -main, -extended, and -nvidia

## Features

### -main
- Start with a Fedora image
- Adds the following packages to the base image:
  - Hardware acceleration and codecs
  - `distrobox` for terminal CLI and user package installation
  - A selection of [udev rules and service units](https://github.com/ublue-os/config)
  - Various other tools: check out the [complete list of packages](packages.json)
- Sets automatic staging of updates for the system
- Sets flatpaks to update twice a day
- Everything else (desktop, artwork, etc) remains stock so you can use this as a good starting image

### -extended
- Builds on the -main image and adds the following kmod packages:
  - v4l2loopback
  - xpadneo (WIP)
- The kernel modules are signed to enable secure boot, however you need to [enroll the key](#Enroll-Secure-Boot-Key) 

### -nvidia
- Build on the -extended image, adds nvidia driver support and also:
  - [Container runtime support](https://github.com/ublue-os/nvidia#using-nvidia-gpus-in-containers)
  - [Hardware-accelerated video playback](https://github.com/ublue-os/nvidia#video-playback)
- The kernel modules are signed to enable secure boot, however you need to [enroll the key](#Enroll-Secure-Boot-Key)  
- To set up the nVidia driver properly some [post-installation commands](#nVidia-Settings) are needed

## Tips and Tricks

These images are immutable, you can't, and really shouldn't, install packages like in a mutable "normal" distribution.
Applications should be installed using Flatpak whenever possible (execpt for IDEs in some cases, more below).
Should that not be possible, you can use [distrobox](https://github.com/89luca89/distrobox) to have images of mutable distributions where you can install applications normally.
Want an application that is only available on Arch Linux *and* one that is only on Ubuntu? Well, now can have both!

Distrobox is very powerful, for example you can use to [host your entire development environment](https://github.com/89luca89/distrobox/blob/main/docs/posts/integrate_vscode_distrobox.md) completely separate from your host system. Or use it to run a [container for your virtual machines](https://github.com/89luca89/distrobox/blob/main/docs/posts/run_libvirt_in_distrobox.md).

ublue-os/base-main is also very well suited for servers, and users are expected to make full use of `podman` to host containers running "typical" server software i.e. `nginx`, `caddy` and others. 

## How to Install

We are working on an installer, but for now you need to rebase from an existing fedora-ostree distribution.
To rebase an existing Silverblue/Kinoite machine to the latest release (37): 

1. Download and install [Fedora Silverblue](https://silverblue.fedoraproject.org/download)
1. After you reboot you should [pin the working deployment](https://docs.fedoraproject.org/en-US/fedora-silverblue/faq/#_about_using_silverblue) so you can safely rollback 
1. Open a terminal and use one of the following commands to rebase the OS:

```rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/{image}-{variant}:37```

Where {image} is:

| {Image} | Desktop Environment | Supported Version |
| :-----: | :-----------------: | :---------------: |
| Silverblue | GNOME | 37, 38 |
| Kinoite | KDE | 37, 38 |
| vauxite | XFCE | 37, 38 |
| sericea | sway | 38 |
| base | none | 37, 38 |
| lxqt | LXQt | 37, 38 |
| mate | MATE | 37, 38 |



And {variant} is either "main" or "extended".

E.g.:

    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main:37

or

    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/kinoite-extended:37

If you need nvidia drivers user the following: 

|     | 525xx series | 520xx series | 470xx series (Kepler 2012-2014 support) |
|-----|:------------:|:------------:|:---------------------------------------:|
| F37 | :latest / :37 / :37-525 / :37-current | :37-520 | 37-470 |
| F38 | :38 / :38-525 / :38-current |  |  |

E.g.

    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-nvidia:latest

or 

    rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-kionite:37-470

## Post Installation 
### Enroll Secure Boot Key
If you are using the -extended or -nvidia image you need to import the signing key:

    just enroll-secure-boot-key

On the next reboot you will be prompted to enroll the key.

### nVidia Settings

Settings the kargs to enable nvidia drivers is currently not supported in containers and you have to do so yourself:

    just set-kargs

Additional runtime packages are added for enabling hardware-accelerated video playback. This can the enabled in Firefox (RPM or flatpak) by setting the following options to `true` in `about:config`:

* `gfx.webrender.all`
* `media.ffmpeg.vaapi.enabled`

Should you wish to use the firefox flatpak, extensive host access and reduced sandboxing is needed for it to use `/usr/lib64/dri/nvidia_drv_video.so`:

    just setup-firefox-flatpak-vaapi

Firefox is by default installed as an RPM, and this is not needed.
## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/base

If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.

## Configuring Automatic Updates

> **Warning**
> 
> Disabling automatic updates is an unsupported configuration. If you reconfigure updates, you MUST be on the latest image before opening any issues.

With that said, you can individually disable which automatic update timers [ublue-os/config](https://github.com/ublue-os/config) provides with the following commands:

* flatpak system: `sudo systemctl disable flatpak-system-update.timer`
* flatpak user: `sudo systemctl --global disable flatpak-user-update.timer`

You can also configure automatic `rpm-ostree` updates by editing `/etc/rpm-ostreed.conf` and changing "AutomaticUpdatePolicy" to "none" or "check":

```
[Daemon]
AutomaticUpdatePolicy=check
```

## Making your own

See [the documentation](https://ublue.it/making-your-own/) on how use this image in your own projects.

### Architecture

This image can be used as an end user desktop or as something to derive from.
[The architecture](https://ublue.it/architecture/) looks like this:

![](https://ublue.it/ublue-architecture-graph.png)

### Adding Applications

Edit the `packages.json` file with your preferred applications.
Flatpak installation is a WIP.

