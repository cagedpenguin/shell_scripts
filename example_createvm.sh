/usr/bin/virt-install \
  --virt-type=kvm \
  --name $NAME \
  --ram $RAM \
  --vcpus $CPUS \
  --os-variant=rhel6 \
  --hvm \
  --location="http://mirror.cs.vt.edu/pub/CentOS/6.8/os/x86_64/" \
  --network bridge=virbr0 \
  --graphics vnc \
  --extra-args="ks=http://192.168.1.191/ks/centos6.cfg ip=dhcp console=tty0 console=ttyS0,115200n8" \
  --disk path="$VGHOME/$NAME.img",size=$DISKSIZE,bus=virtio
