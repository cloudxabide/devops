#!/bin/bash
gsettings list-recursively | grep -i enabled-extensions
 gsettings set org.gnome.desktop.background show-desktop-icons true
 gsettings set org.gnome.desktop.calendar show-weekdate true
 gsettings set org.gnome.desktop.interface clock-show-date true
 gsettings set org.gnome.desktop.interface clock-show-weekday true
 gsettings set org.gnome.desktop.interface show-battery-percentage true
 gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'
 gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
 gsettings set org.gnome.shell enabled-extensions "['background-logo@fedorahosted.org', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'openweather-extension@jenslody.de', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'TopIcons@phocean.net', 'freon@UshakovVasilii_Github.yahoo.com', 'activities-config@nls1729']"
 gsettings set org.gnome.shell.extensions.openweather city '44.9772995,-93.2654691>Minneapolis, Hennepin County, Minnesota, United States of America >-1'
 gsettings set org.gnome.Terminal.Legacy.Keybindings reset-and-clear '<Primary><Shift>k'
 
