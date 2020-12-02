#!/bin/bash

# Name:     OSX.sh
# Version:  1.1
# Purpose:  To update a fresh OSX install with DevOps Tools
# Notes:    You should view README.md.  
#           Script is not idempotent - not sure what would happen if run several multiple times.
#           Some of these steps must be in order - and see the previous "warning"

# Update /etc/sudoers to allow NOPASSWD
## TODO: make this scriptable

# Change shell BACK to bash 
chsh -s /bin/bash
/bin/bash
# Local setup
curl -o ~/.bashrc https://raw.githubusercontent.com/cloudxabide/devops/master/FILES/.bashrc
curl -o ~/.bash_profile https://raw.githubusercontent.com/cloudxabide/devops/master/FILES/.bash_profile
. ~/.bash_profile

# My Parameters
MYHOSTNAME="neo"

# Update System Names (based on Parameters above)
sudo scutil --set HostName "$MYHOSTNAME"
sudo scutil --set LocalHostName "$MYHOSTNAME"
sudo scutil --set ComputerName "$MYHOSTNAME"

# I put the following in a "routine" so that this can be run as a script 
#   (and ignore the following which needs to be done prior to this 
#   script being run (chicken-egg)
manual_steps() {
# Create your Github SSH key (and manually add your SSH key to your github)
ssh-keygen -trsa -b2048 -f ~/.ssh/id_rsa-github-cloudxabide

# Update your local SSH config
curl -o ~/.ssh/config https://raw.githubusercontent.com/cloudxabide/devops/master/FILES/config; chmod 0600 ~/.ssh/config
}


# Install Xcode
xcode-select --install

# Clone this repo
[ ! -d ~/Repositories/cloudxabide ] && { mkdir -p ~/Repositories/cloudxabide; cd $_; git clone git@github.com:cloudxabide/devops.git; }

# OS X Desktop Tweaks
# Enable "tap-to-click" (not sure whether sudo is needed - does not seem to work)
# http://osxdaily.com/2014/01/31/turn-on-mac-touch-to-click-command-line/
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Set Dark Mode
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true

# Tweak GIT
#git config --global user.name "Your Name"
#git config --global user.email you@example.com
#git config --global core.excludesfile ~/.gitignore_global
cat << EOF > ~/.gitconfig
[core]
	excludesfile = /Users/jradtke/.gitignore_global
[user]
	name = James Radtke
	email = emailaddy@gmail.com
EOF
echo ".DS_Store" >> ~/.gitignore_global

# Optimize VIM
# See [vim_foo.sh](./vim_foo.sh)
bash <(curl -s https://raw.githubusercontent.com/cloudxabide/devops/master/Scripts/vim_foo.sh)

# See if there is an existing ~/.ssh - if not, create one (with keys)
[ -d ${HOME}/.ssh ] || ssh-keygen -trsa -b2048
# The next command should have already been executed (above)
# curl -o ~/.ssh/config https://raw.githubusercontent.com/cloudxabide/devops/master/FILES/config;  chmod 0600 ~/.ssh/config

# Install Homebrew  (https://brew.sh) 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Old (deprecated) method
#   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Optional: you should add this to your .profile or .bashrc (etc...)
grep "opt/python" ~/.bashrc || { echo "PATH=\"$PATH:/usr/local/opt/python/libexec/bin:$PATH" >> ~/.bashrc; }
 
# Install Cask (FKA http://caskroom.io/)
# Homebrew-Cask extends Homebrew and allows you to install large binary files via a command-line tool
brew tap homebrew/cask                      # Tap the Caskroom/Cask repository from Github using HTTPS.

# Install Python 3.x
brew install python

# Install iTerm2
brew install --cask iterm2

# Install  Viscosity (OS X VPN client)
brew install cask viscosity

# Install Microsoft Visual Studio Code
#brew search visual-studio-code        # Searches all known Casks for a partial or exact match.
brew info --cask visual-studio-code     # Displays information about the given Cask
brew install --cask visual-studio-code  # Install the given cask.

# Install Atom
## Visit https://www.code2bits.com
#brew search atom                      # Searches all known Casks for a partial or exact match.
brew info --cask atom                   # Displays information about the given Cask
brew install --cask atom                # Install the given cask.

# Install Asciidoctor stuff
sudo gem install asciidoctor-pdf asciidoctor-diagram rouge

# Install Slack
brew install --cask slack

# Install Google Chrome
brew install --cask google-chrome

# Install Steam Client
#brew install --cask steam

## Install PIP
curl  https://bootstrap.pypa.io/get-pip.py -o ~/get-pip.py
python3 ~/get-pip.py 
rm ~/get-pip.py

# Install AWS CLI
# NOTE: The PIP method seems all fooked right now

## https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html
#pip install awscli --upgrade --user
#echo "PATH=\"$(dirname $( find ~/Library/Python/ -name aws)):$PATH\" " >> ~/.bashrc

# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd-all-users
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
mv AWSCLIV2.pkg ~/Downloads

#curl "https://awscli.amazonaws.com/AWSCLIV2-2.0.30.pkg" -o "AWSCLIV2.pkg"
#sudo installer -pkg AWSCLIV2.pkg -target /

# Install Terraform
brew install --cask terraform

# Install Steam Client
#brew install --cask steam 

# Install Microsoft Office (huh?)
#brew install --cask microsoft-office

# Install VMware Fusion
#brew install --cask vmware-fusion

###### ###### ###### ######
# Install some Gnu utils 
# Install a "sane" version of sed.
brew install gnu-sed
#-- add the following to your .bash_profile/.bashrc/etc...
grep "gnu-sed" ~/.bashrc || { echo "PATH=\"/usr/local/opt/gnu-sed/libexec/gnubin:$PATH\" " >> ~/.bashrc; }
brew install tree
brew install wget

# Conky
# https://github.com/Conky-for-macOS/conky-for-macOS/wiki
#brew cask install xquartz
#brew tap Conky-for-macOS/homebrew-formulae
#brew install conky-all 

#  LASTLY....
# Update Brew (should not be necessary at this time, here for a reference)
brew update                           # Fetch latest version of homebrew and formula.
brew cleanup                          # For all installed or specific formulae, remove any older versions from the cellar.

exit 0
##########################


# Install GRIP  (GitHub Readme Instant Preview)
## Not entirely sure this is worth messing around with. (Atom has a built-in md viewer)
## https://github.com/joeyespo/grip
#brew install grip

## References:
https://docs.python-guide.org/starting/install3/osx/
http://caskroom.io/
https://www.code2bits.com/how-to-install-atom-on-macos-using-homebrew/
https://pythonbasics.org/
