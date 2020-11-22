#!/bin/bash


GOVCLOUD=0
case $GOVCLOUD in
  0) OWNERS="309956199498"; REGIONS="us-east-1 us-east-2 us-west-1 us-west-2" ;;
  *) OWNERS="219670896067"; REGIONS="us-gov-east-1 us-gov-west-1";;
esac


for REGION in $REGIONS
do
  echo "$OWNERS: $REGION"
done
