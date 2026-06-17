#!/bin/bash

# Purpose:  Install OS utilities and apps

# Install utilities
PKGS_COMMON="unzip wget curl lsb-release"
# Source /etc/os-release to get distribution info
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
        ubuntu)
            echo "This is Ubuntu"
            SYSTEM_PACKAGES="git"
            sudo apt-get -y install $SYSTEM_PACKAGES 
            sudo apt-get -y install $PKGS_COMMON
        ;;
        suse | opensuse* | sles | sled)
            echo "This is SUSE"
            which lsb_release &>/dev/null || sudo zypper --non-interactive install lsb-release
            PKGS="git-core "
            sudo zypper --gpg-auto-import-keys --non-interactive install --auto-agree-with-licenses $PKGS
            sudo zypper --gpg-auto-import-keys --non-interactive install --auto-agree-with-licenses $PKGS_COMMON
        ;;
        *)
            echo "Unknown or unsupported OS: $ID"
        ;;
    esac
else
    echo "/etc/os-release not found. Unable to determine OS."
fi

# =====================================
# Let's focus on DevOps Packages

export SYSTEM_PKGS="lsb-release iotop sysstat"

do_ubuntu() {
apt -y install $SYSTEM_PKGS
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

# Add Microsoft Repo (for VSCode)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper --non-interactive ar  https://packages.microsoft.com/yumrepos/vscode vscode

# Google Chrome (does not work for aarch64/arm64)
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > linux_signing_key.pub
sudo rpm --import linux_signing_key.pub; sudo rm linux_signing_key.pub
sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/$(uname -p) Google-Chrome

sudo zypper --gpg-auto-import-keys refresh

zypper --non-interactive install $SYSTEM_PKGS

# I put this in a for-loop so that one bad package does not prevent the others from installing
PKG_LIST="code npm nodejs gnome-terminal google-chrome-stable"
for PKG in $PKG_LIST; do sudo zypper --non-interactive install --auto-agree-with-licenses $PKG; done
}

## OS-specific
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
        ubuntu) do_ubuntu;;
        suse | opensuse* | sles | sled) do_suse;;
        *) echo "Unknown or unsupported OS: $ID";;
    esac
else
    echo "/etc/os-release not found. Unable to determine OS."
fi

## Universal Install
# Update Bootloader Screen
wget -O - https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash
# wget -O - https://github.com/johdasgran/mr-robot-theme/raw/main/install.sh | bash

# Install the AWS CLI (TODO: make this OS-independent)
#curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -p).zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install && rm -rf ./aws awscliv2.zip

# Install Kubectl - Kubectl uses different "nomenclature" to identify processor architecture
case $(uname -m) in
    x86_64) PLATFORM="amd64" ;;
    aarch64) PLATFORM="arm64" ;;
    arm64) PLATFORM="arm64" ;;
esac
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${PLATFORM}/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${PLATFORM}/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check | grep OK && { sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; rm ./kubectl*; } || { echo "Checksum failed.  Review."; }

# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash
