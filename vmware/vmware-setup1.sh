#!/usr/bin/env bash

set -o errexit
set -o nounset

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y upgrade
apt-get -y install linux-image-extra-virtual quota # this installs the necessary kernel bits for quotas
sed -i.bak -e's/remount-ro/remount-ro,usrquota,grpquota/' /etc/fstab
reboot
