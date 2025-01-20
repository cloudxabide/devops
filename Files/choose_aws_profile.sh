#!/bin/bash -x
#profiles=($(perl -lne '/\[\K[^\]]+/ and print $&' ${HOME}/.aws/credentials ))
profiles=$(aws configure list-profiles)
PS3='Profile number: '
export AWS_SHARED_CREDENTIALS_FILE=${HOME}/.aws/credentials
echo " "
echo "-------------------------------"
echo "Please select a profile to load"
echo "-------------------------------"
select choice in "${profiles[@]}"
do
  export AWS_PROFILE=$choice
  export AWS_DEFAULT_PROFILE=$choice
  echo "-------------------------------"
  echo "AWS CLI profile set to "$choice
  echo "-------------------------------"
  echo " "
  break
done
