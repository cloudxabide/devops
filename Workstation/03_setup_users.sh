#!/bin/bash

# Status:  Work in Progress
#          Trying to make this entire script non-interactive
#          This script should be an Ansible playbook, or TF even.  :shrug:
#   NOTE:  This will be a script to run-as root (and not rely on sudo)
#          Allowing the "user setup" script to be run as the user who
#             wishes to update their own ENV
#  RunAs:  root

# * * * * * * * * * * * *
# System Stuff
# * * * * * * * * * * * *
MYDIR=$(pwd)
DATE=`date +%Y%m%d`
ARCH=`uname -p`
YUM=$(which dnf || which yum || which zypper)
THISOS=$(lsb_release -is)
OS_NAME=$(grep ^NAME /etc/os-release | awk -F\" '{ print $2 }')

if [ $(whoami) != "root" ]
then
  echo "ERROR:  You should be root to run this... exiting in 10 seconds (hit CTRL-C)"
  sleep 10
  exit 9
fi

# Make sure the host is named correctly
case $(dmidecode -s baseboard-product-name) in
  21CD000QUS)
    echo "blackmesa" > /etc/hostname
  ;;
  0F6K9V)
    echo "wheatley" > /etc/hostname
  ;;
  'ROG STRIX Z490-E GAMING')
    echo "jarvis" > /etc/hostname
  ;;
esac

# Task: Setup Users (SUSE uses a common group for all users)
# Create user using dummy Passw0rd - you need to change your password
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
      opensuse*|sles|sled)
        groupadd -g 2025 jradtke
        id -u jradtke &>/dev/null || useradd -u2025 -g2025 -Gusers,wheel -c "James Radtke" -m -p '$6$Yyap4/fOS9I4tBAY$c0mDtGG46vO1tS3Idp3/NmamZgupUqL1o8ERWObYtKmw.jvGyuSZvhOeCUWFOE.8osZj6whiQ5l0VfWFDaPhH.' jradtke
      ;;
      "ubuntu")
        groupadd -g 2025 jradtke
        id -u jradtke &>/dev/null || useradd -u2025 -g2025 -Gsudo,users -c "James Radtke" -m -p '$6$Yyap4/fOS9I4tBAY$c0mDtGG46vO1tS3Idp3/NmamZgupUqL1o8ERWObYtKmw.jvGyuSZvhOeCUWFOE.8osZj6whiQ5l0VfWFDaPhH.' -s /bin/bash jradtke
      ;;
      *)
         id -u jradtke &>/dev/null || useradd -u2025  -c "James Radtke" -p '$6$Yyap4/fOS9I4tBAY$c0mDtGG46vO1tS3Idp3/NmamZgupUqL1o8ERWObYtKmw.jvGyuSZvhOeCUWFOE.8osZj6whiQ5l0VfWFDaPhH.' jradtke
      ;;
    esac
else
    echo "/etc/os-release not found. Unable to determine OS."
fi

# Task: SUDO setup
SUDOERS="jradtke mansible"
for DAUSER in $SUDOERS
do
  echo "$DAUSER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$DAUSER-nopasswd-all
done

# Task: Remove specific users from the login screen
DAUSERS="mansible sophos image-builder"
for DAUSER in $DAUSERS
do
echo "[User]
Language=en_US.UTF-8
XSession=gnome
SystemAccount=true" | sudo tee /var/lib/AccountsService/users/$DAUSER
done

exit 0
