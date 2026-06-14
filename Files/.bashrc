# filename: ~/.bashrc

# This file is stored/managed at: https://raw.githubusercontent.com/cloudxabide/devops/main/Files/
# grep cxa-customization ~/.bashrc || { curl https://raw.githubusercontent.com/cloudxabide/devops/main/Files/.bashrc | tee -a ~/.bashrc; }

# cxa-customization follows 
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
  if [ -f "$rc" ]; then
    [ ! -z $TROUBLESHOOT_BASH ] && { echo "### Sourcing: $rc from ~/.bashrc"; }
    . "$rc"
    fi
  done
fi

unset rc

# Ingest and export creds for bashrc.d/* scripts that exist
# Safely iterate over the directory using globbing instead of $(find ...)
for RC in "$HOME"/.bashrc.d/*
do
  # Guard against an empty directory (where the literal string '* ' is returned)
  [[ -e "$RC" ]] || continue

  # Properly quote variables to prevent issues with spaces in file paths
  CREDS_FILE="${HOME}/.config/$(basename "$RC")/creds"
  # echo "sourcing $CREDS_FILE"

  # Use [[ ... ]] for file testing instead of arithmetic (( ... ))
  [[ -f "$CREDS_FILE" ]] && source "$CREDS_FILE"
done

unset RC
