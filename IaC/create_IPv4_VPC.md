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
SUBNET_AZ1="us-west-2a"
SUBNET_AZ2="us-west-2b"
SUBNET_AZ3="us-west-2c"

SUBNET_AZ1_PUBLIC_CIDR="10.0.1.0/24"
SUBNET_AZ1_PUBLIC_NAME="10.0.1.0 - $SUBNET_AZ1"

SUBNET_AZ2_PUBLIC_CIDR="10.0.2.0/24"
SUBNET_AZ2_PUBLIC_NAME="10.0.2.0 - $SUBNET_AZ2"

SUBNET_AZ3_PRIVATE_CIDR="10.0.3.0"
SUBNET_AZ3_PRIVATE_NAME="10.0.3.0 - $SUBNET_AZ3"
HEALTHCHECK_FREQUENCY="5"

# Set a default region (just in case)
aws configure set region $AWS_REGION

# ==========================================
# ==========================================
##   VPCs
# ==========================================
# ==========================================
#- Create VPC
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $AWS_REGION)

#- tag the VPC
aws ec2 create-tags \
  --resources $VPC_ID \
  --tags="Key=Name,Value=$VPC_NAME" \
  --region $AWS_REGION

# ==========================================
# ==========================================
##   Subnets
# ==========================================
# ==========================================
#- Create the public subnet
SUBNET_AZ1_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id=$VPC_ID \
  --cidr-block $SUBNET_AZ1_PUBLIC_CIDR \
  --availability-zone $SUBNET_AZ1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
#- Tag the subnet
aws ec2 create-tags \
  --resources $SUBNET_AZ1_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET_AZ1_PUBLIC_NAME" \
  --region $AWS_REGION

#- Create the public subnet
SUBNET_AZ2_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id=$VPC_ID \
  --cidr-block $SUBNET_AZ2_PUBLIC_CIDR \
  --availability-zone $SUBNET_AZ2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
#- Tag the subnet
aws ec2 create-tags \
  --resources $SUBNET_AZ2_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET_AZ2_PUBLIC_NAME" \
  --region $AWS_REGION

#- Create the private subnet
SUBNET_AZ3_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id=$VPC_ID \
  --cidr-block $SUBNET_AZ3_PRIVATE_CIDR \
  --availability-zone $SUBNET_AZ3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
#- Tag the subnet
aws ec2 create-tags \
  --resources $SUBNET_AZ3_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET_AZ3_PUBLIC_NAME" \
  --region $AWS_REGION

# ==========================================
# ==========================================
##   Internet Gateways and Route Table
# ==========================================
# ==========================================
#- Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text \
  --region $AWS_REGION)
#- Attach the Internet Gateway
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID \
  --region $AWS_REGION

#- Create Route Table
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $AWS_REGION)

#- Create route to Internet Gateway
RESULT=$(aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID \
  --region $AWS_REGION)

#- Associate Public Subnet (AZ1) with Route Table
#- Enable
#- Associate Public Subnet (AZ2) with Route Table

# ==========================================
# ==========================================
# ==========================================
# ==========================================


# ==========================================
# ==========================================
# ==========================================
# ==========================================
```
## References
```
$ aws ec2 create-default-vpc


$ aws ec2 delete-vpc --vpc-id vpc-01083f57025ca24f0
```
