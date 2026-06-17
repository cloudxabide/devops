#!/bin/bash

do_fedora(){
            echo "This is Fedora"
            $(which lsb_release) || yum -y install lsb-release
            PKGS="unzip curl wget git iotop"
            sudo yum -y install $PKGS
}
do_ubuntu(){
echo "This is Ubuntu"
SYSTEM_PACKAGES="wget gpg curl git npm"
sudo apt-get -y install $SYSTEM_PACKAGES
}

do_suse(){
# Kill the packagekit stuff so we can actually manage packages.
SVCS="packagekit-background.service
packagekit-offline-update.service
packagekit-background.timer
packagekit.service"
for SVC in $SVCS
do
  echo "systemctl stop $SVC"
  sudo systemctl stop $SVC
done
sudo pkill packagekitd

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper --non-interactive ar  https://packages.microsoft.com/yumrepos/vscode vscode
}

## OS-specific
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
        fedora) do_fedora;;
        ubuntu) do_ubuntu;;
        suse | opensuse* | sles | sled) do_suse;;
        *) echo "Unknown or unsupported OS: $ID";;
    esac
else
    echo "/etc/os-release not found. Unable to determine OS."
fi

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'

# Google Chrome (does not work for aarch64/arm64)
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > linux_signing_key.pub
sudo rpm --import linux_signing_key.pub; sudo rm linux_signing_key.pub
sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/$(uname -p) Google-Chrome

sudo zypper --gpg-auto-import-keys refresh

PKG_LIST="lsb-release google-chrome-stable"
for PKG in $PKG_LIST
do
  sudo zypper --non-interactive install $PKG
done

PKG_LIST="code git-core npm nodejs gnome-terminal google-chrome-stable"
for PKG in $PKG_LIST; do sudo zypper --non-interactive install --auto-agree-with-licenses $PKG; done

## Universal Install
# Update Bootloader Screen
wget -O - https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash
wget -O - https://github.com/johdasgran/mr-robot-theme/raw/main/install.sh | bash

[ ! -d /boot/grub2/themes ] && mkdir -p /boot/grub2/themes
cd /boot/grub2/themes
git clone https://github.com/Jacksaur/CRT-Amber-GRUB-Theme.git
git clone https://github.com/cloudxabide/minegrub-theme.git
find /boot/grub2/themes/ -name theme.txt
cd
