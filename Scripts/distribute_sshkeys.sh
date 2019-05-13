#!/bin/bash

KEYNAME="cxa-2019-q1"
PEMFILE=~/.ssh/${KEYNAME}.pem
PUBFILE=${PEMFILE}.pub
REGIONS="us-west-1 us-west-2 us-east-1 us-east-2"

clear

# EXIT IF PEMFILE DOES NOT EXIST
if [ ! -f ${PEMFILE} ]; then echo "PEM File not found: ${PEMFILE}"; exit 9; fi

# GENERATE THE PUB FILE (IF IT DOESN'T EXIST)
[ -f $PUBFILE ] || ssh-keygen -y -f $PEMFILE > $PUBFILE

echo "# Run the following commands to distribute your keys"
for REGION in $REGIONS
do 
  echo "aws ec2 import-key-pair --region ${REGION} --key-name \"${KEYNAME}\" --public-key-material file://${PUBFILE}"
  #aws ec2 import-key-pair --region ${REGION} --key-name "${KEYNAME}" --public-key-material file://${PUBFILE}
done


