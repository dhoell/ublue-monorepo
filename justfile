default:
    @just --list

enroll-secure-boot-key:
    sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der

