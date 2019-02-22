#!/bin/bash

# OSX.sh
# ver: 1
# You should view README.md

# Install Xcode
xcode-select --install

# OS X Desktop Tweaks
# Enable "tap-to-click" (not sure whether sudo is needed)
# http://osxdaily.com/2014/01/31/turn-on-mac-touch-to-click-command-line/
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Set Dark Mode

# Tweak GIT
git config --global core.excludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global

# Optimize VIM
# See [vim_foo.sh](./vim_foo.sh)
bash <(curl -s https://raw.githubusercontent.com/cloudxabide/devops/master/vim_foo.sh)

# Local setup
curl -o ~/.bashrc https://raw.githubusercontent.com/ridexabide/workstation/master/FILES/.bashrc
curl -o ~/.bash_profile https://raw.githubusercontent.com/ridexabide/workstation/master/FILES/.bash_profile
[ -d .ssh ] || ssh-keygen -trsa -b2048
curl -o ~/.ssh/config https://raw.githubusercontent.com/ridexabide/workstation/master/FILES/config
chmod 0600 ~/.ssh/config

# Install Python 3.x
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# you should add this to your .profile or .bashrc (etc...)
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
brew install python

# Install Cask
## http://caskroom.io/
brew tap caskroom/cask            # Tap the Caskroom/Cask repository from Github using HTTPS.

# Install Atom
## Visit https://www.code2bits.com
brew update                       # Fetch latest version of homebrew and formula.
brew search atom                  # Searches all known Casks for a partial or exact match.
brew cask info atom               # Displays information about the given Cask
brew cask install atom            # Install the given cask.
brew cleanup                      # For all installed or specific formulae, remove any older versions from the cellar.

# Install GRIP  (GitHub Readme Instant Preview)
## Not entirely sure this is worth messing around with. (Atom has a built-in md viewer)
## https://github.com/joeyespo/grip
brew install grip

brew install tree

# Install AWS CLI
## https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
pip install awscli --upgrade --user

# Install Chrome (using homebrew)
case `hostname -f | sed -e 's/^[^.]*\.//'` in
  ant.amazon.com)
    echo "Install Chrome from Self-Service Apps"
  ;;
  *)
      brew cask install google-chrome
  ;;
esac

exit 0

## References:
https://docs.python-guide.org/starting/install3/osx/
http://caskroom.io/
https://www.code2bits.com/how-to-install-atom-on-macos-using-homebrew/
https://pythonbasics.org/
