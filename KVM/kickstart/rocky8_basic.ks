# PRE-INSTALLATION SCRIPT
%pre --interpreter=/usr/bin/bash --log=/root/anaconda-ks-pre.log
# Clear the Master Boot Record
dd if=/dev/zero of=/dev/vda bs=512 count=1
## Set the disk partition type
parted -s /dev/vda mklabel gpt
## Boot UEFI disk
parted -s /dev/vda mkpart primary fat32 1MB 512MB
parted -s /dev/vda set 1 boot on
## Boot partition and LVM
parted -s /dev/vda mkpart primary xfs 512MB 2560MB
parted -s /dev/vda mkpart primary xfs 2560MB 100% 
parted -s /dev/vda set 3 lvm on
%end

# Install mode
text
skipx

# Install from
# cdrom
url --mirrorlist="https://mirrors.rockylinux.org/mirrorlist?repo=rocky-BaseOS-8.10&arch=x86_64"

# Repo's
repo --name="BaseOS" --baseurl=http://dl.rockylinux.org/pub/rocky/8/BaseOS/$basearch/os/ --cost=200
repo --name="AppStream" --baseurl=http://dl.rockylinux.org/pub/rocky/8/AppStream/$basearch/os/ --cost=200
repo --name="PowerTools" --baseurl=http://dl.rockylinux.org/pub/rocky/8/PowerTools/$basearch/os/ --cost=200
repo --name="extras" --baseurl=http://dl.rockylinux.org/pub/rocky/8/extras/$basearch/os --cost=200
repo --name="epel" --baseurl=https://dl.fedoraproject.org/pub/epel/8/Everything/$basearch/ --cost=200
repo --name="epel-modular" --baseurl=https://dl.fedoraproject.org/pub/epel/8/Modular/$basearch/ --cost=200

# Timezone/Keyboard
timezone --utc America/New_York
lang en_US.UTF-8
keyboard --vckeymap us

# Run the Setup Agent on first boot
firstboot --disable

# Root password
rootpw *SETTHIS* 
auth --enableshadow --passalgo=sha512

# Firewall configuration
firewall --enabled --ssh

# SELinux configuration
# selinux --enforcing
selinux --disabled

# Network information
# DHCP Example
# network  --bootproto=dhcp --device=eth0 --onboot=on
# STATIC IP Example
# network --device eth0 --hostname kstest --bootproto=static --ip=192.168.2.105 --netmask=255.255.255.0 --gateway=192.168.2.1 --nameserver=192.168.2.1
# network --device=link --hostname="localhost.localdomain" --bootproto=static --ip=192.168.1.208 --netmask=255.255.255.0 --gateway=192.168.1.1 --nameserver=192.168.1.1 --onboot=on --noipv6 --activate
network --device=enp1s0 --bootproto=static --ip=192.168.1.209 --netmask=255.255.255.0 --gateway=192.168.1.1 --nameserver=192.168.1.1 --noipv6
network --hostname="localhost.localdomain"

# System bootloader configuration
bootloader --append="console=ttyS0,115200 console=tty0 inst.gpt" --location=mbr --timeout=5 --boot-drive=vda

# Partitions
part /boot/efi --fstype=vfat --fsoptions='defaults,umask=0027,fmask=0077,uid=0,gid=0' --onpart=/dev/vda1
part /boot --fstype=xfs --fsoptions='nosuid,nodev' --onpart=/dev/vda2
part pv.01 --size=40960  --grow --asprimary --onpart=/dev/vda3
volgroup vg_os pv.01
logvol swap --fstype=swap --size=8192 --name=swap --vgname=vg_os
logvol / --fstype=xfs --size=32768 --grow --name=root --vgname=vg_os
#autopart

# Packages
%packages
@core
epel-release
dnf
dnf-utils
chrony
openssh-server
%end

# KDUMP disabled
%addon com_redhat_kdump --disable
%end

# Services
services --enabled=chronyd,sshd

%post --log=/root/ks-post.log
dnf update -y
%end

# Post install
eula --agreed
shutdown

################## END
################## NOTES
# SET THESE
# WHERE="/opt/kvm"
# ISO="Rocky-9-latest-x86_64-minimal.iso"
# KS="rocky9_basic.ks"
# VAR="rocky9"
#
#  virt-install \
#    --virt-type=kvm \
#    --name $1 \
#    --ram $2 \
#    --vcpus=$3 \
#    --os-variant=$VAR \
#    --virt-type=kvm \
#    --hvm \
#    --location=$WHERE/ISOS/$ISO \
#    --network bridge=br0 \
#    --graphics vnc \
#    --boot uefi --boot useserial=on \
#    --disk path="/var/lib/libvirt/images/$1.img",size=$4,bus=virtio \
#    --extra-args="inst.ks=file:/$KS console=tty0 console=ttyS0,115200n8" \
#    --initrd-inject $WHERE/kickstart/$KS \
#    --noautoconsole
