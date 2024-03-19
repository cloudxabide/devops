#!/bin/bash

#
# @(#)$Id$
#
# Purpose:  A script to iterate through the local git repos (personal and public) on my machine 
#             and execute a task.  I currently have 231 repos from 41 users - I wanted a way to
#             quickly/easily make sure they were all current, and this script will do that.

# NOTES:  "checkout main" in a loop is not "simple" due to the fact that many repos are actually
#           still using "master"


clear 

# Variables
export ERRMSG=""

# Subroutines
usage() {
  echo ""
  echo "$0 -r {public|private|personal|<blank>} -c {status|pull|fetch|remote}"
  echo "$0 <blank> -- runs \"$0 personal status\" as a default"
  echo ""
  exit 0
}

run_check() {
case $COMMAND in
  status)
    echo "# Executing: $COMMAND against $REPO"
    # THIS IS A FOOKING HACK - porcelain will produce a A or M in the second character location
    #echo -e "cd $REPO \n git status --porcelain | egrep [AM]\n  cd -"
    #cd $REPO && git status --porcelain | egrep ^\ [AM] && ERRMSG="$ERRMSG $REPO \n" 
    # Instead try the following:
    echo -e "cd $REPO \ngit diff --exit-code; if [ \$? -ne 0 ]; then ERRMSG=\"\$ERRMSG \$REPO \\\n\"; fi \ncd -"
    cd $REPO 
    git diff --exit-code > /dev/null 2>&1 ; if [ $? -ne 0 ]; then ERRMSG="$ERRMSG $REPO \n"; fi
    cd - > /dev/null 2>&1
    echo ""
  ;;
  pull|fetch)
    echo "# Executing:  git $COMMAND against $REPO"
    echo "cd $REPO &&  git $COMMAND; cd -" 
    #echo "PWD:  `pwd`"
    cd $REPO && git $COMMAND
    cd -
    echo ""
  ;;
  remote)
    echo "# Executing:  git remote -v against $REPO"
    echo "cd $REPO &&  git $COMMAND; cd -" 
    cd $REPO && git $COMMAND -v
    cd -
    echo ""
  ;;
  *)
    echo "ERROR: $COMMAND is an unrecognized command"
    exit 9
  ;;

esac
}

while getopts "r:c:h" opt; do
  case ${opt} in
    r)
      REPOS=$OPTARG
    ;;
    c)
      COMMAND=$OPTARG
    ;;
    h)
      usage
    ;;
    *)
      usage
    ;;
  esac
done
shift $((OPTIND -1))

###  DO SOME REPORTING AND VARIABLE SETTING
# REPORT "BEFORE"
echo "Original:  $0 $1 $2"
if [ -z $REPOS ]; then REPOS="personal"; fi
if [ -z $COMMAND ]; then COMMAND="status"; fi
# REPORT "AFTER"
echo "Updated: $0 -r $REPOS -c $COMMAND"

case $REPOS in 
  private|Private)
   for REPO in `find Private  -name .git | egrep -v '.arch|archive' | sed 's/\.git//g'`
   do 
     echo "################ ################ "
     echo "$REPO"
     run_check
     echo ""
   done
  ;;
  public|Public)
    for REPO in `find Public -name .git -exec dirname {} \; | egrep -v 'archive'`
    do
      echo "################ ################ "
      run_check
      echo ""
    done
  ;;
  personal|Personal)
    for REPO in `find Personal -name .git -exec dirname {} \; | egrep -v 'archive'`
    do
      echo "################ ################ "
      run_check
      echo ""
    done
  ;;
  *)
    usage
  ;;
esac

if [[ ! -z $ERRMSG ]]; then echo -e "NOTE: Go review \n $ERRMSG"; fi

exit 0
