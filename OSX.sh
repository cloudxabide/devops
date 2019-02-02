#!/bin/bash

# View README.md

#  Install Xcode 
xcode-select --install

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
# http://caskroom.io/
brew tap caskroom/cask            # Tap the Caskroom/Cask repository from Github using HTTPS.

# Install Atom
# Visit https://www.code2bits.com
brew update                       # Fetch latest version of homebrew and formula.
brew search atom                  # Searches all known Casks for a partial or exact match.
brew cask info atom               # Displays information about the given Cask
brew cask install atom            # Install the given cask.
brew cleanup                      # For all installed or specific formulae, remove any older versions from the cellar.

# Install AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
pip install awscli --upgrade --user

# Install Chrome
case `hostname -f | sed -e 's/^[^.]*\.//'` in
  ant.amazon.com)
    echo "Install Chrome from Self-Service Apps"
  ;;
  *)
      brew cask install google-chrome
  ;;
esac

exit 0

https://docs.python-guide.org/starting/install3/osx/
http://caskroom.io/

https://www.code2bits.com/how-to-install-atom-on-macos-using-homebrew/

https://pythonbasics.org/
