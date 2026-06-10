#!/bin/bash

# the worst malware out there today for Macs is the corporate supported ones

rm $HOME/Library/LaunchAgents/com.bluejeansnet.BlueJeansHelper.plist
sudo rm /Applications/BlueJeans.app/Contents/Resources/daemon/BlueJeansHelper.app/Contents/MacOS/BlueJeansHelper

sudo rm /Library/LaunchAgents/com.microsoft.OneDriveStandaloneUpdater.plist
sudo rm /Applications/OneDrive.app/Contents/StandaloneUpdater.app/Contents/MacOS/OneDriveStandaloneUpdater
sudo rm "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft Update Assistant.app/Contents/MacOS/Microsoft Update Assistant"
sudo rm /Library/LaunchAgents/com.microsoft.update.agent.plist

