#!/bin/bash

#possible variables
HOST_NAME="arch"
ROOT_PASS="test"
USER_PASS="test"

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
(echo Y) | pacman -S vim base-devel wget rsync openssh
ln -s /usr/bin/vim /usr/bin/vi
#install audio & video drivers as well as xorg
(echo Y) | pacman -S xorg-server xorg-server-utils xorg-xinit mesa
(echo Y) | pacman -S alsa-utils alsa-plugins
(echo Y) | pacman -S xf86-video-intel xf86-video-ati xf86-video-nouveau xf86-video-vesa
#configure and install yaourt
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/$arch" >> /etc/pacman.conf
(echo Y) | pacman -Syu
(echo Y) | pacman -S yaourt
#setup temp root & user password
(echo $ROOT_PASS; echo $ROOT_PASS) | passwd
useradd -m -g users -s /bin/bash bhupendra
(echo $USER_PASS; echo $ROOT_PASS) | passwd bhupendra
echo "bhupendra ALL=(ALL) ALL" >> /etc/sudoers
