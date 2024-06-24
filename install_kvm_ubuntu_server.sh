#!/bin/bash
######################
# This script installs Kernel Virtual Machines on an Ubuntu server
######################

apt-get install \
  qemu-kvm \
  libvirt-bin \
  virtinst \
  bridge-utils \
  ubuntu-vm-builder \
  libosinfo-bin
