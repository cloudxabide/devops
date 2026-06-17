#!/bin/bash

# Purpose:  Register host, manage Repos, update host, fix grub
# Prereqs:  You will need to export a registration code for whichever OS are working with here.
#           REGCODE - code to register node
#           REGEMAIL (optional) - used for SUES reg
#   RunAs:  root

# Determine what OS/Release we are working with
if [ -f /etc/os-release ]; then
    # Source the file to load the variables
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
    NAME=$PRETTY_NAME
else
    # Fallback for very old systems (e.g., SLES 11)
    OS=$(uname -s)
    VERSION=$(uname -r)
    NAME=$OS
fi
ARCH=$(uname -m)

echo "Operating System: $OS"
echo "Version: $VERSION"
echo "Full Name: $NAME"

# Prompt for RGS registration unless USE_RGS was pre-exported
if [ -z "${USE_RGS+x}" ]; then
    read -t 5 -p "Is this an RGS host? [y/N] (defaulting to N in 5s): " _rgs_answer || true
    case "${_rgs_answer,,}" in
        y|yes) USE_RGS=true ;;
        *)     USE_RGS=false ;;
    esac
    echo "USE_RGS=${USE_RGS}"
fi

# So... about "having a single script for multiple variants...
# This code determines which OS (and whether we are using RGS) then registers node and adds a repo
case "$ID" in
  suse | opensuse* | sles | sled)
    echo "This is SUSE"
    DISTRO=$(. /etc/os-release && echo "sles${VERSION_ID%%.*}" | tr '[:upper:]' '[:lower:]')
    case "$USE_RGS" in 
      true|1)
        SUSEConnect --url https://rgscc.ranchergovernment.com --write-config -r $REGCODE
        SUSEConnect -p "PackageHub/${VERSION}/${ARCH}"
      ;; 
      *)
        SUSEConnect -e $REGEMAIL -r $REGCODE
      ;;
    esac
  ;;
  ubuntu)
    echo "This is Ubuntu"
    pro attach $REGCODE
  ;;
  *)
    echo "Unknown or unsupported OS: $ID"
  ;;
esac

# Update GRUB prior to update so that grub tweaks get applied by any updates that modify grub
cp /etc/default/grub /etc/default/grub.orig
sed -i -e 's/#GRUB_SAVEDEFAULT/GRUB_SAVEDEFAULT/g' /etc/default/grub
sed -i -e 's/GRUB_DISABLE_OS_PROBER="true"/GRUB_DISABLE_OS_PROBER="false"/' /etc/default/grub
sed -i -e 's/# GRUB_SAVEDEFAULT="true"/GRUB_SAVEDEFAULT="true"/g' /etc/default/grub

case "$ID" in
  suse | opensuse* | sles | sled)
    echo "This is SUSE"
    zypper --non-interactive install --auto-agree-with-licenses os-prober  
  ;;
esac

# Update Host
case "$ID" in
  suse | opensuse* | sles | sled)
    echo "This is SUSE"
    zypper up
  ;;
  ubuntu)
    echo "This is Ubuntu"
    apt update && apt -y upgrade
  ;;
  *)
    echo "Unknown or unsupported OS: $ID"
  ;;
esac

exit 0
