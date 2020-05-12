#!/bin/bash

# Name:     OSX.sh
# Version:  1.1
# Purpose:  To update a fresh OSX install with DevOps Tools
# Notes:    You should view README.md.  
#           Script is not idempotent - not sure what would happen if run several multiple times.

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
mkdir -p ~/Repositories/cloudxabide
cd $_
git clone git@github.com:cloudxabide/devops.git

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

# Local setup
curl -o ~/.bashrc https://raw.githubusercontent.com/cloudxabide/devops/master/FILES/.bashrc
curl -o ~/.bash_profile https://raw.githubusercontent.com/cloudxabide/devops/master/FILES/.bash_profile
. ~/.bash_profile

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
brew cask install iterm2

# Install Microsoft Visual Studio Code
brew search visual-studio-code        # Searches all known Casks for a partial or exact match.
brew cask info visual-studio-code     # Displays information about the given Cask
brew cask install visual-studio-code  # Install the given cask.

# Update Brew (should not be necessary at this time, here for a reference)
brew update                           # Fetch latest version of homebrew and formula.

# Install Atom
## Visit https://www.code2bits.com
brew tap homebrew/cask                # Tap the Caskroom/Cask repository from Github using HTTPS.
brew search atom                      # Searches all known Casks for a partial or exact match.
brew cask info atom                   # Displays information about the given Cask
brew cask install atom                # Install the given cask.

# Install Microsoft Office (huh?)
#brew cask install microsoft-office

# Install Slack
brew cask install slack

# Install Google Chrome
brew cask install google-chrome

# Install Steam Client
#brew cask install steam

# Install AWS CLI
## https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html
curl -O https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python3 /tmp/get-pip.py --user
pip install awscli --upgrade --user

# Install Steam Client
#brew cask install steam 

# Install VMware Fusion
#brew cask install vmware-fusion

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
brew cleanup                          # For all installed or specific formulae, remove any older versions from the cellar.

exit 0
##########################


# Install Chrome (using homebrew)
case `hostname -f | sed -e 's/^[^.]*\.//'` in
  ant.amazon.com)
    echo "Install Chrome from Self-Service Apps"
  ;;
  *)
      brew cask install google-chrome
  ;;
esac

# Install GRIP  (GitHub Readme Instant Preview)
## Not entirely sure this is worth messing around with. (Atom has a built-in md viewer)
## https://github.com/joeyespo/grip
brew install grip

### This section is for AWS Amplify
# https://aws-amplify.github.io/docs/js/start?ref=amplify-rn-btn&platform=react-native
# Install Node.js and npm
install_Amplify() {
  mkdir -p ~/Projects/Amplify ; cd $_
  brew install npm node.js yarn node watchman
  brew install yarn
  brew install node
  brew install watchman
  npm install -g @aws-amplify/cli
  npm install -g create-react-native-app
  npm install -g react-native-macos-cli
  npm install -g react-native-cli
  npm install --save -g aws-amplify
  npm install --save -g aws-amplify-react-native
}

## References:
https://docs.python-guide.org/starting/install3/osx/
http://caskroom.io/
https://www.code2bits.com/how-to-install-atom-on-macos-using-homebrew/
https://pythonbasics.org/
