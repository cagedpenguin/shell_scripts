#!/bin/bash
###########################################
# SET THESE
WHERE="/home/USER"
ISO="CentOS-7-x86_64-Everything-1908.iso"
KS="centos7_basic.ks"
###########################################

# RUN IT
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "$0 name_of_virt ram_amount(2048 = 2 gigs) vcpu_count size_of_disk"
  echo "$0 devlinux1 2048 2 40"
else
  virt-install \
    --virt-type=kvm \
    --name $1 \
    --ram $2 \
    --vcpus=$3 \
    --os-variant=centos7.0 \
    --virt-type=kvm \
    --hvm \
    --location=$WHERE/ISOS/$ISO \
    --network=bridge=br0,model=virtio \
    --graphics vnc \
    --disk path="/var/lib/libvirt/images/$1.img",size=$4,bus=virtio \
    --extra-args="ks=file:/$KS console=tty0 console=ttyS0,115200n8" \
    --initrd-inject $WHERE/kickstart/$KS \
    --noautoconsole
fi
