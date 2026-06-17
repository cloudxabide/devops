#!/bin/bash

#      Purpose: I will use this (single) script to setup my user-environment, depending on which OS I am running
#        RunAs: anyone  
# Requirements: The user running this script must have SUDO
#               lsb-release package must be install

OS_NAME=$(grep ^NAME /etc/os-release | awk -F\" '{ print $2 }')

# Update files in ${HOME}
cd
for FILE in .bash_profile .bashrc 
do
  cp $FILE ${FILE}.orig 2>/dev/null 
  echo "curl -o ${FILE} https://raw.githubusercontent.com/cloudxabide/devops/main/Files/${FILE}"
  curl -o ${FILE} https://raw.githubusercontent.com/cloudxabide/devops/main/Files/${FILE}
done

# This does not work - .gitconfig is ignored, and therefore does not exist in my repo.  Hmmmm...
curl -o ${HOME}/.gitconfig https://raw.githubusercontent.com/cloudxabide/devops/refs/heads/main/Files/home_.gitconfig
[ ! -d  ${HOME}/.config/git/ ] && mkdir -p ${HOME}/.config/git/
echo "curl -o ${HOME}/.config/git/ignore https://raw.githubusercontent.com/cloudxabide/devops/refs/heads/main/Files/.config_git_ignore.$(uname)"
curl -o ${HOME}/.config/git/ignore https://raw.githubusercontent.com/cloudxabide/devops/refs/heads/main/Files/.config_git_ignore.$(uname)

# Update bash profile(s)
mkdir -p ${HOME}/.bashrc.d/
curl -o ${HOME}/.bashrc.d/common https://raw.githubusercontent.com/cloudxabide/devops/refs/heads/main/Files/.bashrc.d_common
curl -o ${HOME}/.bashrc.d/K8s https://raw.githubusercontent.com/cloudxabide/devops/refs/heads/main/Files/.bashrc.d_K8s
curl -o ${HOME}/.bashrc.d/$OS_NAME https://raw.githubusercontent.com/cloudxabide/devops/refs/heads/main/Files/.bashrc.d_${OS_NAME}

# TODO: make this section only run on Linux hosts
# Add a Conky Startup Desktop App Shortcut
cat << EOF | sudo tee /usr/share/applications/conky.desktop
[Desktop Entry]
Name=Conky
GenericName=Conky
Type=Application
Icon=conky-manager
Terminal=false
Exec=/usr/bin/conky
Hidden=false
NoDisplay=false
Comment=Conky Startup
X-GNOME-Autostart-enabled=true
EOF
[ ! -d $HOME/.config/autostart ] && { mkdir -p $HOME/.config/autostart; chown $(id -u):$(id -g) $_;  }

cat << EOF | sudo tee  $HOME/.config/autostart/Conky.desktop
[Desktop Entry]
Name=Conky
GenericName=ConkyStartup
Comment=Start conky after login
Exec=/usr/bin/conky -c "$HOME/.conky/Conky_Seamod/conky_seamod"
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF
sudo chown -R $(id -u):$(id -g) $HOME/.config/
#  NOTE:  You'll need to rename "~/.conky/Conky Seamod" "~/.conky/Conky_Seamod"

exit 0

