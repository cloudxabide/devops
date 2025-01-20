#!/bin/bash 
# Purpose: script to gather AWS Profiles and present them as a numbered
#            option to select

PROFILES=($(aws configure list-profiles ))
PS3='Profile number: '
export AWS_SHARED_CREDENTIALS_FILE=${HOME}/.aws/credentials
echo " "
echo "-------------------------------"
echo "Please select a profile to load"
echo "-------------------------------"
select CHOICE in "${PROFILES[@]}"
do
  export AWS_PROFILE=$CHOICE
  export AWS_DEFAULT_PROFILE=$CHOICE
  echo "-------------------------------"
  echo "AWS CLI profile set to "$CHOICE
  echo "-------------------------------"
  echo " "
  break
done
