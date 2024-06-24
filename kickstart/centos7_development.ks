# RAN AS KVM KS.CFG
# Example use in KVM
#    /usr/bin/virt-install \
#      --virt-type=kvm \
#      --name wbmongo01 \
#      --ram 2048 \
#      --vcpus 2 \
#      --os-variant=rhel7 \
#      --hvm \
#      --location="/var/lib/libvirt/boot/centos7.iso" \
#      --network bridge=virbr0 \
#      --graphics vnc \
#      --extra-args="ks=http://0.0.0.10/ks/centos7-apache_mongo.cfg ip=0.0.0.20 netmask=255.255.255.0 gateway=0.0.0.1 dns=8.8.8.8 console=tty0 console=ttyS0,115200n8" \
#      --disk path="/var/lib/libvirt/images/wbmongo01.img",size=40,bus=virtio

# Install mode
text
skipx
install

# Install from
url --url http://mirror.cs.vt.edu/pub/CentOS/7/os/x86_64/
#cdrom

# Root password
rootpw PASSWORD
authconfig --enableshadow --passalgo=sha512

# Firewall configuration
# firewall --enabled --ssh
# firewall --disabled
firewall --enabled --ssh

# SELinux configuration
# selinux --enforcing
selinux --disabled

# Timezone/Keyboard
timezone --utc America/New_York
lang en_US.UTF-8
keyboard us

# Network information
# DHCP Example
# network  --bootproto=dhcp --device=eth0 --onboot=on
# STATIC IP Example
# network --device eth0 --hostname kstest --bootproto=static --ip=0.0.0.105 --netmask=255.255.255.0 --gateway=0.0.0.1 --nameserver=0.0.0.1
network --onboot=on --device eth0 --hostname devlinux2 --bootproto=static --ip=0.0.0.207 --netmask=255.255.255.0 --gateway=0.0.0.64 --nameserver=8.8.8.8,8.8.4.4

# firstboot
firstboot --disable
shutdown

# System bootloader configuration
bootloader --location=mbr --boot-drive=vda
zerombr
# Partition clearing information
clearpart --none

# Examples
# If you just don't want to use LVM, just use this
# part /boot --fstype="ext4" --size=512
# part swap --fstype="swap" --recommended
# part /var --fstype="ext4" --size=5120
# part / --fstype="ext4" --size=1024
# part /usr --fstype="ext4" --size=3072
# part /home --fstype="ext4" --size=512
# part /tmp --fstype="ext4" --size=1024

# Logical Volume example
# Disk partitioning information
# part /boot --fstype ext3 --size=150
# part swap --size=1024
# part pv.01 --size=1 --grow
# volgroup vg_root pv.01
# logvol  /  --vgname=vg_root  --size=8192  --name=lv_root
# logvol  /var  --vgname=vg_root  --size=4096  --name=lv_var
# logvol  /tmp  --vgname=vg_root  --size=2048  --name=lv_tmp
# logvol  /spare  --vgname=vg_root  --size=1  --grow  --name=lv_spare

part /boot --fstype ext2 --size=512 --asprimary
part swap --fstype swap --size=4096 --asprimary
part / --fstype ext4 --size=4096 --grow --asprimary

# Services
services --enabled=chronyd,ntpdate,network,sshd

# Pre
%pre
parted -s /dev/vda mklabel
%end

# Packages
%packages  --nobase
@core
%end

%post
rpm -U https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
rpm -U https://centos7.iuscommunity.org/ius-release.rpm
rpm --import http://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY
yum -y update
yum -y install openssh-clients openssh-server rsync wget mlocate net-tools bind-utils tcdump
%end
