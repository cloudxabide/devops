# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment and startup programs
TERM=vt100
EDITOR=vi
VISUAL=vi
MYHOSTNAME=`hostname | cut -f1 -d.`
GIT_EDTIOR=vim
TITLE="`/usr/bin/whoami`@`hostname -s`"
HISTCONTROL=ignoredups

# User specific aliases and functions
alias ll="/bin/ls -l"
alias la="/bin/ls -la"
alias please='/usr/bin/sudo $(history -p !!)'
alias butwhy='/usr/bin/systemctl status $_ '

# Use vi as the EDITOR
set -o vi

# OS-specific optimization
case `uname` in
  Linux)
    alias ls="/bin/ls -N "
    alias vms="sudo virsh list --inactive --all"
    alias vv="sudo virt-viewer ${1}"
  ;;
  Darwin)  # for Apple Mac OS X
    PATH="/usr/local/opt/python/libexec/bin:${HOME}/Library/Python/3.7/bin:$PATH"
  ;;
  SunOS)
    PS1="`/usr/ucb/whoami`@${MYHOSTNAME} $ "
    echo "\033]0; `uname -n` - `/usr/ucb/whoami` \007"
    PATH=$PATH:/usr/sfw/bin:/opt/sfw/bin:/usr/sfw/sbin:/opt/sfw/sbin:/usr/openwin/bin
    PATH=$PATH:/usr/ucb/:/usr/platform/sun4u/bin:/usr/platform/i86pc:/usr/ccs/bin
    PATH=$PATH:/opt/VRTS/bin:/opt/VRTSvcs/bin:/usr/openv/netbackup/bin
    PATH=$PATH:/usr/openv/volmgr/bin:/opt/SUNWsrspx/bin:/opt/SUNWppro/bin
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/sfw/lib:/opt/sfw/lib
  ;;
  AIX)
    PS1="`/usr/bin/whoami`@${HOSTNAME} $ "
    echo "\033]0; ${HOSTNAME} - `/usr/bin/whoami` \007";
  ;;
esac
export PATH PS1 MANPATH LD_LIBRARY_PATH TERM EDITOR VISUAL GIT_EDITOR

# google-chrome-stable --force-device-scale-factor=1.4
