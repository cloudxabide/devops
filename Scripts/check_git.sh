#!/bin/bash

clear 
# Variables
ERRMSG=" "

# Subroutines
usage() {
  echo "$0 -r {public|private|<blank>} -c {status|pull}"
  echo "$0 <blank> -- runs \"$0 private status\" as a default"
}

run_check(){
case $COMMAND in
  status)
    echo "# Executing:  git $COMMAND against $REPO"
    echo "cd $REPO &&  git status --porcelain | egrep [AM]; cd -"
    # THIS IS A FOOKING HACK - porcelain will produce a A or M in the second character location
    cd $REPO && git status --porcelain | egrep ^\ [AM] && ERRMSG="$ERRMSG $REPO \n" 
    cd -
    echo ""
  ;;
  pull)
    echo "# Executing:  git $COMMAND against $REPO"
    echo "cd $REPO &&  git $COMMAND; cd -" 
    #echo "PWD:  `pwd`"
    cd $REPO && git $COMMAND
    cd -
    echo ""
  ;;
esac
}

while getopts "r:c:" opt; do
  case ${opt} in
    r)
      REPOS=$OPTARG
    ;;
    c)
      COMMAND=$OPTARG
    ;;
    *)
      usage
    ;;
  esac
done
shift $((OPTIND -1))

###  DO SOME REPORTING AND VARIABLE SETTING
# REPORT "BEFORE"
echo "$0 -r $REPOS -c $COMMAND"
if [ -z $REPOS ]; then REPOS="private"; fi
if [ -z $COMMAND ]; then COMMAND="status"; fi
# REPORT "AFTER"
echo "$0 -r $REPOS -c $COMMAND"

case $REPOS in 
  private)
   echo "private"
   for REPO in `find . -name .git | sed 's/.git//g' | grep -v Public`
   do 
     echo "################ ################ "
     run_check
     echo ""
   done
  ;;
  public)
    for REPO in `find Public -name .git | sed 's/.git//g'`
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
