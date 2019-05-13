#!/bin/bash

# Purpose:  I wanted a quick way to review ALL the repos I have cached locally, as well as
#           my own repos that I am working with.
#           I have 2 "structures" that I follow for my Git Repos
#             ~/Repositories/Public/<repo-owner>/<repo-name> (Public Repos)
#             ~/Repositories/<my-repo-owner>/<repo-name> (My Personal Repos)
#           I create a symlink to this script in ~/Repositories and run it
#             from there

COMMAND=" "
COMMANDS=" "
ERRMSG=""
SCRIPTPARAM="$1"

usage() {
  echo "USAGE:  $0 {<blank>|public|private}"
  echo "<blank> - if you leave it blank, it will check public and private"
  echo "public|private - decide whether you are going to review the public or priv repos"
  exit 9
}

do_private() {
for REPO in `find . -name .git | sed 's/.git//g' | grep -v Public`
do
  clear
  echo "###################"
  echo "cd $REPO"
  cd $REPO
  for COMMAND in $COMMANDS
  do
    echo "Evaluating: $REPO"
    echo "git $COMMAND"
    git $COMMAND --porcelain | egrep [AM] && ERRMSG="$ERRMSG $REPO \n"
    # This does not work (git exit codes)
    # 'new file|modified'
    #[ $? == 0 ] || ERRMSG="$ERRMSG $REPO \n"
    echo ""
  done
  echo "# go back... cd -"
  cd -
  echo ""
  echo "###################"
  sleep 2
done
}

do_public() {
for COMMAND in $COMMANDS
do
  for REPO in `find . -name .git | sed 's/.git//g' | grep Public`
  do
    echo "###################"
    echo "Managing: $REPO"
    echo "cd $REPO; git $COMMAND; cd -"
    cd $REPO; git $COMMAND; cd -
    echo ""
  done
done
}

# MAIN
if [ $# -gt 1 ]; then usage; fi

case "$SCRIPTPARAM" in 
  "private")
    COMMANDS="status "
    do_private "$COMMANDS"
  ;;
  "public")
    COMMANDS="pull "
    do_public "$COMMANDS"
  ;;
  "" )  
    COMMANDS="status "
    do_private "$COMMANDS"
    do_public "$COMMANDS"
  ;; 
  *)
    usage
  ;;
esac
 
if  [[ ! -z $ERRMSG ]]
then
  echo "NOTE:  Go review"
  echo -e "$ERRMSG"
fi

exit 0
