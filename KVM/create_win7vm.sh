#!/bin/bash
WHERE="/home/USER"

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "$0 name_of_virt ram_amount(2048 = 2 gigs) vcpu_count size_of_disk"
  echo "$0 devlinux1 2048 2 40"
else
  virt-install \
    --virt-type=kvm \
    --name $1 \
    --ram $2 \
    --vcpus=$3 \
    --os-variant=win7 \
    --virt-type=kvm \
    --hvm \
    --disk $WHERE/ISOS/win7_pro.iso,device=cdrom,bus=ide \
    --disk $WHERE/ISOS/virtio-win-drivers-20120712-1.iso,device=cdrom,bus=ide \
    --network=bridge=br0,model=virtio \
    --graphics vnc \
    --disk path="/var/lib/libvirt/images/$1.img",size=$4,bus=virtio
fi
