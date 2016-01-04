#KDE install
pacman -S --noconfirm sddm plasma kcalc konsole leafpad dolphin ark p7zip zip unzip unrar gwenview qt5-imageformats kimageformats jdk8-openjdk icedtea-web libreoffice-fresh hyphen-en libmythes mythes-en kdegraphics-okular simplescreenrecorder amarok ktorrent partitionmanager ntfs-3g dosfstools ncdu cups hplip print-manager sane xsane firefox flashplugin cronie remmina freerdp
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable org.cups.cupsd
systemctl enable cronie
yaourt -S npapi-vlc-git google-chrome google-talkplugin gtk-theme-orion