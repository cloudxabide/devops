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
AMI_ID=$1
SOURCE_REGION=$2
# Get the AMI "Name"
AMI_NAME=$(aws ec2 describe-images --output text --region $SOURCE_REGION --image-id $AMI_ID --query 'Images[].Name')

case $SOURCE_REGION in
  us-east-1) REGIONS="us-east-2 us-west-2 us-west-1";;
  us-east-2) REGIONS="us-east-1 us-west-2 us-west-1";;
  us-west-1) REGIONS="us-east-1 us-east-2 us-west-2";;
  us-west-2) REGIONS="us-east-1 us-east-2 us-west-1";;
  *) echo "ERROR: region ($SOURCE_REGION) not recognized"; exit 9;;
esac

for REGION in $REGIONS
do
  AMI_ID=$(aws ec2 describe-images --output text --region "${REGION}" --filters "Name=name,Values=${AMI_NAME}" --owners self amazon --query 'Images[].ImageId')
  echo "$REGION | $AMI_ID"
done
exit 0
```
