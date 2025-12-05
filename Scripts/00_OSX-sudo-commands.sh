#!/bin/bash

# Name:     OSX.sh
# Version:  1.3
# Purpose:  To update a fresh OSX install with DevOps Tools
# Notes:    You should view README.md.
#           Script is not idempotent - not sure what would happen if run several multiple times.
#           Some of these steps must be in order - and see the previous "warning"

MYHOSTNAME="cyberpunk"
DAUSER=$(whoami)
echo "$DAUSER ALL=(ALL) NOPASSWD: ALL" | sudo tee  /private/etc/sudoers.d/$DAUSER-nopasswd-all

# Update /etc/sudoers to allow NOPASSWD
sudo scutil --set HostName "$MYHOSTNAME"
sudo scutil --set LocalHostName "$MYHOSTNAME"
sudo scutil --set ComputerName "$MYHOSTNAME"

# This is now a clusterfuck due to some security update which requires additional permssions now :-(
xcode-select --install
sleep 1
osascript <<EOD
  tell application "System Events"
    tell process "Install Command Line Developer Tools"
      keystroke return
      click button "Agree" of window "License Agreement"
    end tell
  end tell
EOD
sudo mkdir -p /usr/local/share/man/man5
sudo chown -R $(whoami) /usr/local/share/man/man5

# Install Rosetta non-interactively
case $(sudo sysctl -b machdep.cpu.brand_string) in
  'Apple M1' | 'Apple M2') sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license 
;;
  "*")  echo "Unsupported Processor";;
esac

# Enable "tap-to-click" (not sure whether sudo is needed - does not seem to work)
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
sudo gem install asciidoctor-pdf asciidoctor-diagram rouge

