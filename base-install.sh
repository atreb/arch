#!/bin/bash

#possible variables
DISK_DEVICE="/dev/sda"
ROOT_SPACE="+9G"
HOST_NAME="arch"
ROOT_PASS="test"
USER_PASS="test"

#create partitions - 9G root / and 1G swap assuming 10G /dev/sda
(echo o; echo n; echo p; echo 1; echo ; echo $ROOT_SPACE; echo w) | fdisk /dev/sda
(echo n; echo p; echo 2; echo ; echo ; echo w) | fdisk /dev/sda
(echo a; echo 1; echo w) | fdisk /dev/sda
(echo a; echo 2;) | fdisk /dev/sda
#format partitions
mkfs -t ext4 /dev/sda1
mkswap /dev/sda2
#mount root partition and install base
mount /dev/sda1 /mnt
(echo ; echo y) | pacstrap -i /mnt base
#setup fstab
genfstab -U -p /mnt >> /mnt/etc/fstab
echo "/dev/sda2 none swap defaults 0 0" >> /mnt/etc/fstab

#stuff here to go inside chroot
cat <<EOF > /mnt/root/base-chroot-install.sh
#set timezone
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
#uncomment line in /etc/locale.gen that has #en_US.UTF-8 UTF-8
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
#generate locale
locale-gen
locale > /etc/locale.conf
#setup ntp & manually synchronize your clock with the network & enable it's service
(echo Y) | pacman -S ntp
ntpd -qg
systemctl enable ntpd
#set hardware clock to utc
hwclock --systohc --utc
#set hostname
echo $HOST_NAME > /etc/hostname
#install boot loader,
(echo Y) | pacman -S grub
grub-install --target=i386-pc --recheck --debug /dev/sda
#set swap partition for resume from hibernation
sed -i -e 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"resume=\/dev\/sda2\"/g' /etc/default/grub
#reconfigure grub
grub-mkconfig -o /boot/grub/grub.cfg
#install vim instead of vi & nano along with some common packages
(echo Y) | pacman -Rs vi nano
(echo Y) | pacman -S vim wget rsync openssh sudo
ln -s /usr/bin/vim /usr/bin/vi
(echo ;) | pacman -S base-devel
#install audio & video drivers as well as xorg
(echo Y) | pacman -S xorg-server xorg-server-utils xorg-xinit mesa
(echo Y) | pacman -S alsa-utils alsa-plugins
(echo Y) | pacman -S xf86-video-intel xf86-video-ati xf86-video-nouveau xf86-video-vesa
#configure and install yaourt
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
(echo Y) | pacman -Syu
(echo Y) | pacman -S yaourt
#setup temp root & user password
(echo $ROOT_PASS; echo $ROOT_PASS) | passwd
useradd -m -g users -s /bin/bash bhupendra
(echo $USER_PASS; echo $ROOT_PASS) | passwd bhupendra
echo "bhupendra ALL=(ALL) ALL" >> /etc/sudoers
exit
EOF

chmod 775 /mnt/root/base-chroot-install.sh
arch-chroot /mnt /root/base-chroot-install.sh
#delete file and unmount
rm -rf /mnt/root/base-chroot-install.sh
umount -R /mnt