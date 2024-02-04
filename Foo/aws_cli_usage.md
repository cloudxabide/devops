# AWS CLI Usage 

## VPC 
### Gather VPC info
I need to recreate an existing configuration which resides in us-east-1 and it should be a close as possible to the original

```
aws ec2 describe-vpcs --region us-east-1 --query 'Vpcs[*].CidrBlock' --output table
aws ec2 describe-subnets --region us-east-1 --query 'Subnets[*].[CidrBlock,Tags[?Key==`Name`].Value|[0]]' --output table
aws ec2 describe-internet-gateways --region us-east-1 --query 'InternetGateways[*].Attachments'
```

## EC2 

### AMI Image management
For this particular situation, I was curious how to figure out AMI ImageId for use in several regions (and whether it would be easy to gather this information).  NOTE: I only have one EC2 instance type running in this particular region and with this account.

```
$ aws ec2 describe-instances --output text --query 'Reservations[*].Instances[].ImageId'
ami-55ef662f
$ aws ec2 describe-images --output text --image-id ami-55ef662f --query 'Images[].Name'
amzn-ami-hvm-2017.09.1.20171120-x86_64-gp2
$ aws ec2 describe-images --output text --region --us-west-2 --filters 'Name=name,Values=amzn-ami-hvm-2017.09.1.20171120-x86_64-gp2' --owners self amazon --query 'Images[].ImageId'
ami-bf4193c7
$ aws ec2 describe-images --output text --region us-west-1 --filters 'Name=name,Values=amzn-ami-hvm-2017.09.1.20171120-x86_64-gp2' --owners self amazon --query 'Images[].ImageId'
ami-a51f27c5
```

So - a typical usage for this data would be a CloudFormation mapping
```
"Mappings" : {
  "RegionMap" : {
    "us-west-2"       : { "HVM64" : "ami-bf4193c7"},
    "us-west-1"       : { "HVM64" : "ami-a51f27c5"}
  }
}
```

If I was to script this (using AWS CLI - Python would possibly be better)
```
#!/bin/bash

usage() 
{
  echo "$0 [ami_id] [region]"
  echo "$0 ami-55ef662f us-east-1"

}

if [ $# -ne 2 ]; then usage; fi

# ASSIGN THE VARS TO THE PARAMS PASSED IN
AMI_ID=$1
SOURCE_REGION=$2
DELIM="|"

# Create the list of REGION(s) to poll
case $SOURCE_REGION in
  us-east-1) REGIONS="us-east-2 us-west-2 us-west-1";;
  us-east-2) REGIONS="us-east-1 us-west-2 us-west-1";;
  us-west-1) REGIONS="us-east-1 us-east-2 us-west-2";;
  us-west-2) REGIONS="us-east-1 us-east-2 us-west-1";;
  *) echo "ERROR: region ($SOURCE_REGION) not recognized"; exit 9;;
esac

# Get the AMI "Name" for the AMI_ID
AMI_NAME=$(aws ec2 describe-images --output text --region $SOURCE_REGION --image-id $AMI_ID --query 'Images[].Name')

for REGION in $REGIONS
do
  AMI_ID=$(aws ec2 describe-images --output text --region "${REGION}" --filters "Name=name,Values=${AMI_NAME}" --owners self amazon --query 'Images[].ImageId')
  echo "${REGION} ${DELIM} ${AMI_ID}"
done
exit 0
```
expected output:
```
$ ./blah.sh ami-55ef662f us-east-1
us-east-2 | ami-15e9c770
us-west-2 | ami-bf4193c7
us-west-1 | ami-a51f27c5
```

#### Find images from a company (Red Hat)
Status:  Work In Progress (WIP)
Reference: https://access.redhat.com/solutions/15356
```
GOVCLOUD=0
case $GOVCLOUD in 
  0) OWNERS="309956199498"; REGIONS="us-east-1 us-east-2 us-west-1 us-west-2" ;;
  *) OWNERS="219670896067"; REGIONS="us-gov-east-1 us-gov-west-1";;
esac


for REGION in $REGIONS
do
  echo "$OWNER
done

