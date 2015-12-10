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

## Post install steps

- If you are installing arch on virtualbox, then re-mount /dev/sda1 & arch-chroot /mnt to do following in :
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
- Select plasma session when greeted with login screen
- change root & user password
- install aur packages
```
yaourt -S --noconfirm npapi-vlc-git google-chrome google-talkplugin
```
- in firefox and google-chrome install 'ublock origin' addon/extention