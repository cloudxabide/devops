#!/bin/bash

# Name:     OSX.sh
# Version:  1.3
# Purpose:  To update a fresh OSX install with DevOps Tools
# Notes:    You should view README.md.  
#           Script is not idempotent - not sure what would happen if run several multiple times.
#           Some of these steps must be in order - and see the previous "warning"
#           Removed all the commands which require "sudo" (which is now in OSX-sudo-commands.sh)
# Todo:     make this scriptable (idempotent)
#           Update to run portions based on personal vs work machine

### NOTE !
### NOTE !
### NOTE !  I am trying to fix the PATH in a more scalable way, 
### NOTE !     or forward-looking
### NOTE !  It seems that brew/cask/whatever.. changes the path 
### NOTE !    to binaries at times..

# Routines
brew_finish() {
# Update Brew (should not be necessary at this time, here for a reference)
brew upgrade
brew update     # Fetch latest version of homebrew and formula.
brew cleanup    # For all installed or specific formulae, remove any older versions from the cellar.
}

####
# curl -O https://raw.githubusercontent.com/cloudxabide/devops/main/Scripts/OSX.sh
# 
####
# Change shell BACK to bash (requires password)
#  NOTE:  No longer doing this.  Instead, create a .zshrc that switch to bash if iTerm is the terminal.app
# chsh -s /bin/bash

####
/bin/bash
# Local setup (first copy files in HOME dir, then *.d files)
curl -o ~/.zshrc https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Files/.zshrc
curl -o ~/.bashrc https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Files/.bashrc
curl -o ~/.bash_profile https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Files/.bash_profile

mkdir -p ~/.bashrc.d/
curl -o ~/.bashrc.d/Darwin https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Files/.bashrc.d_Darwin
curl -o ~/.bashrc.d/common https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Files/.bashrc.d_common
. ~/.bash_profile

# I put the following in a "routine" so that this can be run as a script 
#   (and ignore the following which needs to be done prior to this 
#   script being run (chicken-egg)
manual_steps() {
# Create your Github SSH key (and manually add your SSH key to your github)
ssh-keygen -trsa -b2048 -f ~/.ssh/id_rsa-github-cloudxabide

# Update your local SSH config
curl -o ~/.ssh/config https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Files/ssh_config; chmod 0600 ~/.ssh/config
}

# Clone this repo
[ ! -d ~/Repositories/cloudxabide ] && { mkdir -p ~/Repositories/cloudxabide; cd $_; git clone git@github.com:cloudxabide/devops.git; }

# Tweak GIT
cat << EOF > ~/.gitconfig
[core]
  excludesfile = ${HOME}/.config/git/ignore
[user]
  name = James Radtke
  email = emailaddy@gmail.com
[pull]
  rebase = false
[push]
	default = current
EOF

mkdir ~/.config/git
curl -o ${HOME}/.config/git/ignore  https://raw.githubusercontent.com/cloudxabide/devops/main/Files/.config_git_ignore.Darwin

# Optimize VIM (I need to research better VIM setup)
# See [vim_foo.sh](./vim_foo.sh)
# bash <(curl -s https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Scripts/vim_foo.sh)

# See if there is an existing ~/.ssh - if not, create one (with keys)
[ -d ${HOME}/.ssh ] || ssh-keygen -trsa -b2048
# The next command should have already been executed (above)
# curl -o ~/.ssh/config https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Files/ssh_config;  chmod 0600 ~/.ssh/config

# Install Homebrew  (https://brew.sh) 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Old (deprecated) method
#   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install)"
# Optional: you should add this to your .profile or .bashrc (etc...)
# grep "opt/python" ~/.bashrc.d/Darwin || { echo "PATH=\"$PATH:/usr/local/opt/python/libexec/bin:$PATH\"" >> ~/.bashrc.d/Darwin; }

BREWPATH="$(/opt/homebrew/bin/brew --prefix)"

BINPATH="${BREWPATH}/bin"
grep $BINPATH ~/.bashrc.d/Darwin || { echo "PATH=\"\$PATH:$BINPATH\"" >> ~/.bashrc.d/Darwin; }
. ~/.bashrc
 
# Install Cask (FKA http://caskroom.io/)
# Homebrew-Cask extends Homebrew and allows you to install large binary files via a command-line tool
brew tap homebrew/cask                      # Tap the Caskroom/Cask repository from Github using HTTPS.

# Install Python 3.x
brew install python
brew install python-tk@3.9

# Install Java
brew install java 
[ ! -f /Library/Java/JavaVirtualMachines/openjdk.jdk ] && { sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk; }

brew install openjdk@11  
[ ! -f /Library/Java/JavaVirtualMachines/openjdk-11.jdk ] && { sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk; }
# TODO:  Update this to include Java path
#  echo 'export PATH="/usr/local/opt/openjdk/bin:$PATH"' >> ~/.zshrc

## https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html
#pip install awscli --upgrade --user
#echo "PATH=\"$(dirname $( find ~/Library/Python/ -name aws)):$PATH\" " >> ~/.bashrc.d/Darwin

# Install Terraform
brew install terraform

# Balena Etcher (media software)
brew install --cask balenaetcher

###### ###### ###### ######
# Install some Gnu utils 
# Install a "sane" version of sed.
brew install gnu-sed
#-- add the following to your .bash_profile/.bashrc/etc... 
#  NOTE:  I want Gnu-sed to be first in my path
BINPATH="/opt/homebrew/Cellar/gnu-sed/4.9/libexec/gnubin/"
grep $BINPATH ~/.bashrc.d/Darwin || { echo "PATH=\"$BINPATH:\$PATH\"" >> ~/.bashrc.d/Darwin; }

brew install tree
brew install wget
brew install cmake

# Conky
# https://github.com/Conky-for-macOS/conky-for-macOS/wiki
#brew cask install xquartz
#brew tap Conky-for-macOS/homebrew-formulae
#brew install conky-all 

case `hostname -d` in
  ant.amazon.com)
    echo "Wrap up Brew tasks"
    brew_finish
    echo "Note:  completed tasks.  Now exiting."
    exit 0
  ;;
esac

# Install iTerm2
brew install --cask iterm2

# Install  Viscosity (OS X VPN client)
brew install cask viscosity

# Install Microsoft Visual Studio Code
#brew search visual-studio-code        # Searches all known Casks for a partial or exact match.
brew info --cask visual-studio-code     # Displays information about the given Cask
brew install --cask visual-studio-code  # Install the given cask.
brew install --cask microsoft-teams

# Install Asciidoctor stuff (moved this to the sudo script ./OSX-sudo-commands.sh)
#sudo gem install asciidoctor-pdf asciidoctor-diagram rouge

# Install Slack
brew install --cask slack

# Install Miro (desktop App)
brew install miro

# Install Google Chrome
brew install --cask google-chrome

## Install PIP
curl  https://bootstrap.pypa.io/get-pip.py -o ~/get-pip.py
python3 ~/get-pip.py
rm ~/get-pip.py

# Install Microsoft Office (huh?)
brew install --cask microsoft-office

# Install VMware Fusion
#brew install --cask vmware-fusion

#  LASTLY....
# Update Brew (should not be necessary at this time, here for a reference)
brew upgrade
brew update         # Fetch latest version of homebrew and formula.
brew cleanup        # For all installed or specific formulae, remove any older versions from the cellar.

exit 0
