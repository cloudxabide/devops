#!/bin/bash

# Purpose:   Script to sync my Music Library between Mac hosts
#    Date:   2023-08-01
#  Status:  Work in Progress
#   Notes:  I had to separate out the Music from the Library due to forcing the sync of the Library.
#    Todo:  Need to confirm that the paths/options/etc... all work as expected

# To test syntax generate the commands to run
#   for HOST in glados cyberpunk squanchy; do for COMMAND in push pull; do echo ./sync_libraries.sh -c $COMMAND -s $HOST; done; done

# clear 

# Variables
FORTKNOX="cyberpunk"
THISHOST=$(hostname -s)
ERRMSG=""
RSYNC_OPTIONS_MEDIA="-vaE --delete"
RSYNC_OPTIONS_LIBRARY="-vaE --delete"
MEDIA_PATH="/Users/jradtke/Music/Music/"
MUSIC_LIBRARY_PATH="/Users/jradtke/Music/Music/Music Library.musiclibrary/"
MUSIC_CACHE_PATH="/Users/jradtke/Library/Caches/com.apple.Music"

# Subroutines
usage() {
  echo ""
  echo "$0 -c {push|pull} -s [sync hostname]"
  echo "   -c = command"
  echo "   -s = hostname of host to sync with"
  echo ""
  echo "Example: "
  echo "$0 -c push -s cyberpunk"
  echo ""
  if [[ ! -z $ERRMSG ]]; then echo "ERROR: $ERRMSG"; fi
  echo ""
  exit 0
}

run_command() {
case $COMMAND in
  push)
    SOURCEHOST=$THISHOST
    DESTINATIONHOST=$SYNCHOST
    echo "rsync $RSYNC_OPTIONS_MEDIA $MEDIA_PATH $DESTINATIONHOST:$MEDIA_PATH"
    echo "rsync $RSYNC_OPTIONS_LIBRARY \"$MUSIC_LIBRARY_PATH\" $DESTINATIONHOST:'"$MUSIC_LIBRARY_PATH"' "
    # echo "rsync $RSYNC_OPTIONS_LIBRARY \"$MUSIC_CACHE_PATH\" $DESTINATIONHOST:'"$MUSIC_CACHE_PATH"' "
    echo ""
  ;;
  pull|fetch)
    SOURCEHOST=$SYNCHOST
    DESTINATIONHOST=$THISHOST
    echo "rsync $RSYNC_OPTIONS_MEDIA $SOURCEHOST:$MEDIA_PATH $MEDIA_PATH"
    echo "rsync $RSYNC_OPTIONS_LIBRARY $SOURCEHOST:'"$MUSIC_LIBRARY_PATH"' \"$MUSIC_LIBRARY_PATH\" "
    # echo "rsync $RSYNC_OPTIONS_LIBRARY $DESTINATIONHOST:'"$MUSIC_CACHE_PATH"' " \"$MUSIC_CACHE_PATH\" 
    echo ""
  ;;
  *)
    echo "ERROR: $COMMAND is an unrecognized command"
    usage
  ;;
esac
echo -e "Command: $COMMAND\nSourceHost: $SOURCEHOST\nDestinationHost: $DESTINATIONHOST"
echo ""
}

while getopts "c:s:h" opt; do
  case ${opt} in
    c)
      COMMAND=$OPTARG
    ;;
    s)
      SYNCHOST=$OPTARG
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

run_command
if [ $SOURCEHOST = $DESTINATIONHOST ]; then ERRMSG+="You cannot sync from and to the same host"; usage; fi

if [[ ! -z $ERRMSG ]]; then echo -e "NOTE: Go review \n $ERRMSG"; fi

exit 0
