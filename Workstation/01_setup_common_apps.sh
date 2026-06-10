#!/bin/bash

# Install utilities
# Source /etc/os-release to get distribution info
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
        fedora)
            echo "This is Fedora"
            $(which lsb_release) || yum -y install lsb-release
            PKGS="unzip curl wget git iotop"
            sudo yum -y install $PKGS
        ;;
        ubuntu)
            echo "This is Ubuntu"
            SYSTEM_PACKAGES="wget gpg curl git npm"
            sudo apt-get -y install $SYSTEM_PACKAGES
        ;;
        suse | opensuse* | sles | sled)
            echo "This is SUSE"
            $(which lsb_release) || sudo zypper --non-interactive install lsb-release
            PKGS="unzip curl wget git-core iotop"
            sudo zypper --gpg-auto-import-keys --non-interactive install --auto-agree-with-licenses $PKGS
        ;;
        *)
            echo "Unknown or unsupported OS: $ID"
        ;;
    esac
else
    echo "/etc/os-release not found. Unable to determine OS."
fi

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

