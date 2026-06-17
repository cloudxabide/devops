#!/bin/bash

#  Status:  Working (2026-06-17, confirmed on SLES 16)
# Purpose:  Install NVIDIA Drivers from NVIDIA
#    NOTE:  If you are running SLES with subscription, the included drivers from SUSE should work fine.
#             I need to this due to running SLES from RGS

set -euo pipefail

# NVIDIA's docs appear accurate, but there is a bit of work on the reader's part to get
#  through it all.  This script is loosely based on NVIDIA Docs for SLES
# https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/suse.html

USE_FOSS=${USE_FOSS:-false}

distro=$(. /etc/os-release && echo "sles${VERSION_ID%%.*}" | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
version_id=$(. /etc/os-release && echo "${VERSION_ID}")

sudo zypper install -y kernel-default-devel gcc gcc-c++ make

# https://developer.download.nvidia.com/compute/cuda/repos/sles15/x86_64/cuda-sles15.repo
repo_url="https://developer.download.nvidia.com/compute/cuda/repos/${distro}/${arch}/cuda-${distro}.repo"
echo "$repo_url"
if ! sudo zypper repos | grep -q "cuda-${distro}"; then
  sudo zypper addrepo "$repo_url"
fi
sudo zypper --gpg-auto-import-keys refresh

sudo suseconnect -p "PackageHub/${version_id}/${arch}"

lsmod > /tmp/lsmod.0
lspci > /tmp/lspci.0

# G07 meta-packages (cuda-drivers / nvidia-open) require kernel-syms via DKMS,
# which was not available on SLES 15 SP7 but IS available on SLES 16.
# Using G06 KMP packages regardless; G06 covers Turing/Ampere (RTX 3050 Ti and newer).
#
# The CUDA-capable signed KMP conflicts with the plain signed KMP; remove it first.
# Pin all userspace packages to the same version as the KMP to avoid version skew.
DRIVER_VER="580.126.20-1"
KMP_VER="580.126.20_k$(uname -r | sed 's/-default//')"

sudo zypper -n remove nvidia-open-driver-G06-signed-kmp-default 2>/dev/null || true

sudo zypper modifyrepo -e "NVIDIA-GPU-Compute-Toolkit-CUDA"
sudo zypper modifyrepo -e "NVIDIA-Graphics-Drivers"
sudo zypper --gpg-auto-import-keys refresh

## Not sure Version Locking is going to work
case "$USE_FOSS" in
  true)
    sudo zypper -n -v install \
      "nvidia-open-driver-G06-signed-cuda-kmp-default" \
      "nvidia-compute-G06" \
      "nvidia-compute-utils-G06" \
      "nvidia-video-G06" \
      "nvidia-gl-G06"
    ;;
  *)
    sudo zypper -n -v install --auto-agree-with-licenses  \
      "nvidia-open-driver-G06-signed-cuda-kmp-default" \
      "nvidia-compute-G06" \
      "nvidia-compute-utils-G06" \
      "nvidia-video-G06" \
      "nvidia-gl-G06"
    ;;
esac

lsmod > /tmp/lsmod.1
lspci > /tmp/lspci.1
# sdiff exits 1 when files differ; pipefail would abort the script without || true
{ sdiff /tmp/lsmod.0 /tmp/lsmod.1 || true; } | grep -E '[|<>]' || true
{ sdiff /tmp/lspci.0 /tmp/lspci.1 || true; } | grep -E '[|<>]' || true

# Docker stuff
sudo zypper refresh
sudo zypper install -y docker
sudo usermod -a -Gdocker $(whoami)
sudo systemctl enable --now docker

sudo zypper addrepo https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo
sudo zypper --gpg-auto-import-keys refresh
sudo zypper install -y nvidia-container-toolkit nvtop

sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
# NOTE: I have seen that a reboot may be required before the nvidia-smi test completes successfully
sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

exit 0
