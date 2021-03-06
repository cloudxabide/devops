# .bashrc

# THIS FILE WAS DERIVED FROM
# https://github.com/cloudxabide/devops/blob/HEAD/Files/.bashrc
#  Personalize file at the bottom

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
alias ll="/bin/ls -l "
alias la="/bin/ls -la | egrep -v '.DS_Store'"
alias lr="/bin/ls -lart"
alias please='/usr/bin/sudo $(history -p !!)'
alias butwhy='/usr/bin/systemctl status $_ '
alias matrixnet='/usr/bin/sudo route add -net 10.10.10.0 netmask 255.255.255.0 gw 192.168.0.1'
alias unfuckthispieceofshit="sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache"
alias doover="git checkout -- ."

alias oclogin='oc login -u morpheus -p 'NotAPassword' --insecure-skip-tls-verify --server=https://rh7-ocp3-mst.matrix.lab.:8443'

alias gitclean='git branch -d $(git branch | grep `whoami`)'
alias gitdoover='git checkout -- .'
alias gitreset='git checkout -- .'

# Use vi as the EDITOR
set -o vi

# google-chrome-stable --force-device-scale-factor=1.4

# OS-specific optimization
case `uname` in 
  Linux)
    alias ls="/bin/ls -N "
    alias vms="sudo virsh list --inactive --all"
    alias vv="sudo virt-viewer ${1}"
  ;;
  Darwin)
    # Placeholder for Apple Mac OS X
    #alias 
    export BASH_SILENCE_DEPRECATION_WARNING=1
    PATH="/usr/local/opt/python/libexec/bin:${HOME}/Library/Python/3.8/bin:$PATH"
    alias quarantining="echo $(expr '(' $(date -j -v -14d -f \"%Y-%m-%d\" \"2020-08-14\" +%s) - $(date +%s) ')' / 86400) \"days until quarantine begins. \" "
    alias finalcountdown="echo $(expr '(' $(date -j -f \"%Y-%m-%d\" \"2020-08-14\" +%s) - $(date +%s) ')' / 86400) \"days until \#NERDvana .\" "
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

# Entries BELOW this line are custom
# ==============================================

PATH="/usr/local/opt/python/libexec/bin:/Users/jradtke/Library/Python/3.8/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/opt/python/libexec/bin:/Users/jradtke/Library/Python/3.8/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/python/libexec/bin:/Users/jradtke/Library/Python/3.8/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/opt/python/libexec/bin:/Users/jradtke/Library/Python/3.8/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" 
