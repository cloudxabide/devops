# .bash_profile
# This file is stored/managed at: https://raw.githubusercontent.com/cloudxabide/devops/main/Files/

[ ! -z $TROUBLESHOOT_BASH ] && { echo "###### Sourcing:  $0"; }

# Get the aliases and functions
if [ -f ${HOME}/.bashrc ]; then
	. ${HOME}/.bashrc
fi

# User specific environment and startup programs
