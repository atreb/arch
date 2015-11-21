#!/bin/bash

#pre-requirements
#

#possible variables
DISK_DEVICE="/dev/sda"
ROOT_SPACE="+9G"

#create partitions - 9G root / and 1G swap assuming 10G /dev/sda
(echo o; echo n; echo p; echo 1; echo ; echo +9G; echo w) | fdisk /dev/sda
(echo n; echo p; echo 2; echo ; echo ; echo w) | fdisk /dev/sda
(echo a; echo 1; echo w) | fdisk /dev/sda
(echo a; echo 2;) | fdisk /dev/sda
#format partitions
mkfs -t ext4 /dev/sda1
mkswap /dev/sda2
#mount root partition and install base
mount /dev/sda1 /mnt
(echo ; echo y) | pacstrap -i /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab
echo "/dev/sda2 none swap defaults 0 0" >> /mnt/etc/fstab
arch-chroot /mnt
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
