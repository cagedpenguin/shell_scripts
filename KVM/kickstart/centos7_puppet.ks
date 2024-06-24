# RAN AS KVM KS.CFG
# Install mode
text
skipx
install

# Install from
cdrom

# Root password
rootpw PASSWORD
authconfig --enableshadow --passalgo=sha512

# Firewall configuration
firewall --enabled --ssh
# SELinux configuration
# selinux --enforcing
selinux --disabled

timezone --utc America/New_York
lang en_US.UTF-8
keyboard us

# Network information
#network  --bootproto=dhcp --device=eth0 --onboot=on
network --bootproto=static --device=eth0 --onboot=on --ip=0.0.0.143 --netmask=255.255.255.0 --gateway=0.0.0.1 --hostname=molab01 --nameserver=8.8.4.4,8.8.8.8

# firstboot
firstboot --disable
shutdown

# System bootloader configuration
bootloader --location=mbr --boot-drive=vda
zerombr
# Partition clearing information
clearpart --none
# Disk partitioning information
part /boot --fstype ext2 --size=512 --asprimary
part swap --fstype swap --size=2048 --asprimary
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
rpm --import http://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY
rpm -U https://centos7.iuscommunity.org/ius-release.rpm
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y update
yum -y install openssh-clients openssh-server rsync wget mlocate net-tools
yum -y install puppet
%end
