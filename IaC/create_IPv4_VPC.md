# Create IPv4 VPC and Subnets Using CLI

## Overview
In case it is not obvious from viewing the code, many
of the commands provide output that is needed further in
the script

```
#!/bin/bash

AWS_REGION="us-west-2"
VPC_NAME="CXA HexGL"
VPC_CIDR="10.0.0.0/16"
SUBNET_AZ1_PUBLIC_CIDR="10.0.1.0/24"
SUBNET_AZ1_PUBLIC_NAME="10.0.1.0 - us-west-2a"
SUBNET_AZ2_PUBLIC_CIDR="10.0.2.0/24"
SUBNET_AZ2_PUBLIC_NAME="10.0.2.0 - us-west-2b"
SUBNET_AZ3_PRIVATE_CIDR="10.0.3.0"
SUBNET_AZ3_PRIVATE_NAME="10.0.3.0 - us-webt-2c"
HEALTHCHECK_FREQUENCY="5"

# Create VPC
echo "Creating VPC in $AWS_REGION"
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $AWS_REGIONk)
echo "  VPC ID:  $VPC_ID created in $AWS_REGION" 
```

## References
```
$ aws ec2 create-default-vpc


$ aws ec2 delete-vpc --vpc-id vpc-01083f57025ca24f0
```
