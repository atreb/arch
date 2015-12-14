#KDE install
pacman -S --noconfirm sddm plasma
(echo 2; echo Y) | pacman -S kcalc konsole kwrite dolphin ark p7zip zip unzip unrar gwenview qt5-imageformats kimageformats k3b dvd+rw-tools vcdimager transcode emovix jdk8-openjdk icedtea-web libreoffice-fresh hyphen-en libmythes mythes-en kdegraphics-okular simplescreenrecorder amarok ktorrent partitionmanager ntfs-3g dosfstools ncdu cups hplip print-manager sane xsane firefox flashplugin gtk-theme-orion cronie
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable org.cups.cupsd
systemctl enable cronie
