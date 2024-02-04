#!/bin/bash

PWD=`pwd`
DATE=`date +%Y%m%d`
ARCH=`uname -p`
YUM=$(which yum)

if [ `/bin/whoami` != "root" ]
then
  echo "ERROR:  You should be root to run this..."
  exit 9
fi

# Subscription and Repository Management (Red Hat)
subscription-manager status || { subscription-manager register --auto-attach; }
subscription-manager repos --disable="*" --enable=rhel-8-for-x86_64-baseos-rpms --enable=rhel-8-for-x86_64-appstream-rpms --enable "codeready-builder-for-rhel-8-$(uname -m)-rpms"
syspurpose set-role "Red Hat Enterprise Linux Server" 
syspurpose set-sla "Self-Support" 
syspurpose set-usage "Development/Test"

# Third-Party Repository Management (EPEL, RPMfusion, Google, Adobe)
$YUM -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm;
$YUM -y install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
$YUM -y install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm

cat << EOF > /etc/yum.repos.d/google-x86_64.repo
[google64]
name=Google - x86_64
baseurl=http://dl.google.com/linux/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF
rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub

$YUM -y install http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm

#####################
# USER MAINTENANCE
#####################
# (NotAPassword)
id -u mansible &>/dev/null || useradd -u1000 -G10 -c "My Ansible" -p '$6$MIxbq9WNh2oCmaqT$10PxCiJVStBELFM.AKTV3RqRUmqGryrpIStH5wl6YNpAtaQw.Nc/lkk0FT9RdnKlEJEuB81af6GWoBnPFKqIh.' mansible 
id -u morpheus &>/dev/null || useradd -u2001 -G10 -c "Morpheus" -p '$6$MIxbq9WNh2oCmaqT$10PxCiJVStBELFM.AKTV3RqRUmqGryrpIStH5wl6YNpAtaQw.Nc/lkk0FT9RdnKlEJEuB81af6GWoBnPFKqIh.' morpheus 
id -u jradtke &>/dev/null || useradd -u2025 -G10 -c "James Radtke" -p '$6$MIxbq9WNh2oCmaqT$10PxCiJVStBELFM.AKTV3RqRUmqGryrpIStH5wl6YNpAtaQw.Nc/lkk0FT9RdnKlEJEuB81af6GWoBnPFKqIh.' jradtke

# Customize environment for Morpheus
# Add TMPFS mount for user:morpheus
grep morpheus /etc/fstab
if [ $? -ne 0 ]
then
  echo "# TMPFS Mount" >> /etc/fstab
  echo "tmpfs   /home/morpheus tmpfs  rw,size=1G,nr_inodes=5k,noexec,nodev,nosuid,uid=2001,gid=2001,mode=1700   0  0" >> /etc/fstab
  mkdir /home/morpheus
  mount -a
fi

# Setup wheel group for NOPASSWD:
sed -i -e 's/^%wheel/#%wheel/g' /etc/sudoers
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers

# * * * * * * * * * * * *
# PACKAGE MANAGEMENT
# * * * * * * * * * * * *
SYS_PKGS="audit autofs dstat expect gcc git glibc hddtemp intltool iotop kernel-headers kernel-devel lm_sensors nmap openssh-askpass policycoreutils-gui powertop sysfsutils sysstat tuned xorg-x11-xauth"
DEV_PKGS="ansible"
DESKTOP_PKGS="google-chrome-stable java-*-openjdk icedtea-web gimp brasero"
DVD_PKGS="libdvdread libdvdnav xine-lib xine-lib-extras-freeworld mplayer smplayer vlc"
AUDIO_PKGS="gstreamer1* gstreamer* alsa-plugins-pulseaudio"
GNOME_PKGS="gnome-tweak-tool gnome-common"
CD_RECORD="cdparanoia"

MISSING_PKGS="spice-client docky gnome-shell-extension-weather spice-gtk-python gnome-rdp rdesktop tomboy eclipse eclipse-pydev ccsm id3v2"
MISSING_DESKTOP_PKGS="conky conky-manager libreoffice spice-xpi wireshark wireshark-gnome xscreensaver xscreensaver-extras-gss xscreensaver-gl-*"
# INSTALL PACKAGES
$YUM -y install $SYS_PKGS
$YUM -y install $DESKTOP_PKGS
$YUM -y install $DEV_PKGS
$YUM -y install $DVD_PKGS
$YUM -y install $AUDIO_PKGS
$YUM -y install $GNOME_PKGS
$YUM -y install $CD_RECORD

# Optimize gnome-shell
$YUM -y install gnome-shell-extension-*

# * * * * * * * * * * * *
#  GRUB and Plymouth
# * * * * * * * * * * * *
$YUM -y install plymouth-theme-*

# Commented out the theme, I will be using the fallout boy one
cat << EOF >> /etc/default/grub
# Custom stuff
GRUB_DISABLE_RECOVERY="true"
GRUB_SAVEDEFAULT="true"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
#GRUB_THEME="/boot/grub2/themes/starfield/theme.txt"
EOF
# Install Fall Out Grub
wget -O - https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash

sed -i -e 's/console/gfxterm/g' /etc/default/grub
sed -i -e '1i# grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg' /etc/default/grub
sed -i -e '2i# grub2-mkfont --output=/boot/efi/EFI/redhat/unicode.pf2 /usr/share/fonts/dejavu/DejaVuSansMono.ttf' /etc/default/grub
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

plymouth-set-default-theme solar

# * * * * * * * * * * * *
# Setup Custom Build/Test Environment
# * * * * * * * * * * * *
$YUM -y install virt-install virt-manager
systemctl enable libvirtd.service

# Create BIND mount for Libvirt Guests
mkdir /home/images
echo "# BIND Mount for Libvirt Guests" >> /etc/fstab
echo "/home/images /var/lib/libvirt/images none bind,defaults 0 0" >> /etc/fstab
mount -a
restorecon -RFvv /var/lib/libvirt/images

# Customize Web Server
$YUM -y install httpd php
cat << EOF > /etc/httpd/conf.d/OS.conf
Alias "/OS" "/var/www/OS"
<Directory "/var/www/OS">
  Options FollowSymLinks Indexes
</Directory>
EOF
mkdir /var/www/OS; restorecon -RF /var/www/OS
systemctl enable httpd; systemctl start $_
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
rm -rf /var/www/html
ln -s /home/jradtke/Repositories/cloudxabide/aperture.lab /var/www/html

mkdir /var/www/OS/rhel-server-7.7-x86_64
echo "/data/images/rhel-server-7.7-x86_64-dvd.iso /var/www/OS/rhel-server-7.7-x86_64 iso9660 defaults,nofail 0 0" >> /etc/fstab
mount -a

# * * * * * * * * * * * *
#   ClamAV
# * * * * * * * * * * * *
$YUM -y install clamav clamav-data  clamav-filesystem clamav-lib clamav-lib clamav-scanner-systemd clamav-update clamav-unofficial-sigs
sed -i -e 's/^Example/#Example/' /etc/freshclam.conf
sed -i -e 's/db.XY/db.US/' /etc/freshclam.conf
sed -i -e 's/^Example/#Example/' /etc/clamd.d/scan.conf
sed -i -e 's/#LocalSocket/LocalSocket/' /etc/clamd.d/scan.conf

exit 0

# * * * * * * * * * * * *
# Multimedia
# * * * * * * * * * * * *
# Need to research this repo a bit.  
$YUM -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
$YUM -y install flash-plugin icedtea-web 
$YUM -y install vlc smplayer ffmpeg HandBrake-{gui,cli} libdvdcss gstreamer{,1}-plugins-ugly gstreamer-plugins-bad-nonfree gstreamer1-plugins-bad-freeworld

$YUM -y update && shutdown now -r

