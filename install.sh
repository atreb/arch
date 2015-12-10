#!/bin/bash

#possible variables
DISK_DEVICE="/dev/sda"
ROOT_SPACE="+9G"
HOST_NAME="arch"
ROOT_PASS="test"
USER_NAME="bhupendra"
USER_PASS="test"

#create partitions - 9G root / and 1G swap assuming 10G /dev/sda
(echo o; echo n; echo p; echo 1; echo ; echo $ROOT_SPACE; echo w) | fdisk /dev/sda
(echo n; echo p; echo 2; echo ; echo ; echo w) | fdisk /dev/sda
(echo a; echo 1; echo w) | fdisk /dev/sda
(echo a; echo 2;) | fdisk /dev/sda
#format partitions
mkfs -t ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
#mount root partition and install base
mount /dev/sda1 /mnt
pacstrap /mnt base base-devel
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
pacman -S --noconfirm grub
grub-install --target=i386-pc --recheck --debug /dev/sda
#set swap partition for resume from hibernation
sed -i -e 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"resume=\/dev\/sda2\"/g' /etc/default/grub
#reconfigure grub
grub-mkconfig -o /boot/grub/grub.cfg
#install vim instead of vi & nano along with some common packages
pacman -Rs --noconfirm vi nano
pacman -S --noconfirm vim wget rsync openssh git
ln -s /usr/bin/vim /usr/bin/vi
#install audio & video drivers as well as xorg
pacman -S --noconfirm xorg-server xorg-server-utils xorg-xinit mesa alsa-utils alsa-plugins xf86-video-intel xf86-video-vesa
#configure and install yaourt
echo '[archlinuxfr]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = http://repo.archlinux.fr/\$arch' >> /etc/pacman.conf
pacman -Syu --noconfirm
pacman -S --noconfirm yaourt
#setup temp root & user password
(echo $ROOT_PASS; echo $ROOT_PASS) | passwd
useradd -m -g users -s /bin/bash $USER_NAME
(echo $USER_PASS; echo $ROOT_PASS) | passwd $USER_NAME
echo "$USER_NAME ALL=(ALL) ALL" >> /etc/sudoers
#KDE
pacman -S --noconfirm sddm plasma
(echo 2; echo Y) | pacman -S kcalc konsole kwrite dolphin ark p7zip zip unzip unrar gwenview qt5-imageformats kimageformats k3b dvd+rw-tools vcdimager transcode emovix jdk8-openjdk icedtea-web libreoffice-fresh hyphen-en libmythes mythes-en kdegraphics-okular simplescreenrecorder amarok ktorrent partitionmanager ntfs-3g dosfstools ncdu cups hplip print-manager sane xsane firefox flashplugin gtk-theme-orion cronie
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable org.cups.cupsd
systemctl enable cronie
#Home directories
cd /home/$USER_NAME
mkdir -p Downloads Videos Music Pictures Documents DEV/scripts DEV/WORKSPACE
echo 'PATH="/home/$USER_NAME/DEV/scripts:\$PATH"' >> /home/$USER_NAME/.bashrc
exit
EOF

chmod 775 /mnt/root/base-chroot-install.sh
arch-chroot /mnt /root/base-chroot-install.sh
#delete file and unmount
rm -rf /mnt/root/base-chroot-install.sh
umount -R /mnt