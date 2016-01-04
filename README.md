# arch
Helper scripts to get arch linux installed

## Steps for base arch linux with KDE:
- Boot into linux iso image
- Get the base install script
```
wget https://raw.githubusercontent.com/atreb/arch/master/install.sh
```
Open the install.sh script to update the variables if needed
- Change permission for the script to execute
```
chmod 775 install.sh
```
- Run the script.
```
./install.sh
```

## Post install steps for arch guest on virtualbox
Re-mount /dev/sda1 & arch-chroot /mnt to do following in :
```
pacman -S virtualbox-guest-utils
vim /etc/modules-load.d/virtualbox.conf and add following:
 vboxguest
 vboxsf
 vboxvideo
systemctl enable vboxservice
Add following in /etc/modprobe.d/blacklist.conf
 blacklist i2c_piix4
 blacklist intel_rapl
```

## Post install steps for DEs

- Make an initial ramdisk environment (mkinitcpio) using presets (-p) suitable for Linux
```
vi /etc/mkinitcpio.conf and add resume hook after the udev hook to enable hibernate (suspend to disk ie.swap)
HOOKS="... block lvm2 resume filesystems ..."
mkinitcpio -p linux
```
- In firefox and google-chrome install 'ublock origin' addon/extention
- Enable multilib by uncommenting following lines in /etc/pacman.conf
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```
Then we can install few programs that depends on 32bit packages
sudo pacman -S skype
yaourt -S teamviewer
sudo systemctl enable teamviewerd
sudo systemctl start teamviewerd

- improve i/o performance by adding noatime and discard (in case of SSD) options to fstab
- update swapiness and vfs_cache_pressure
To check the currently set values (60 and 100 respectively)
```
sysctl -n vm.swappiness
sysctl -n vm.vfs_cache_pressure
```
setting value for session
```
sudo sysctl -w vm.swappiness=1
sudo sysctl -w vm.vfs_cache_pressure=50
```
permanently setting value, add following in /etc/sysctl.conf
```
vm.swappiness=1
vm.vfs_cache_pressure=50
```
- improve boot time for grub
```
sudo vim /etc/default/grub and change GRUB_TIMEOUT=1
sudo grub-mkconfig -o /boot/grub/grub.cfg
```