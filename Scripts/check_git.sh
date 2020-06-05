#!/bin/bash

clear 
# Variables
ERRMSG=""

# Subroutines
usage() {
  echo ""
  echo "$0 -r {public|private|<blank>} -c {status|pull}"
  echo "$0 <blank> -- runs \"$0 private status\" as a default"
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
if [ -z $REPOS ]; then REPOS="private"; fi
if [ -z $COMMAND ]; then COMMAND="status"; fi
# REPORT "AFTER"
echo "Updated: $0 -r $REPOS -c $COMMAND"

case $REPOS in 
  private)
   for REPO in `find . -name .git | sed 's/.git//g' | grep -v Public`
   do 
     echo "################ ################ "
     run_check
     echo ""
   done
  ;;
  public)
    for REPO in `find Public -name .git -exec dirname {} \; | egrep -v 'archive'`
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
