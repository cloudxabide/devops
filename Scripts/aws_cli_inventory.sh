#!/bin/bash

#
# Status:    Works (also still a work in progress)
# Purpose:   Generically display temps that are available via "thermal_zone"
#            Mostly just wanted to validate my fan works as expected.
# Date:      2020-12-14
#
# Todo:      Need to clean up (make output options consistent)
# Expectations:  You have declared an "AWS_DEFAULT_PROFILE" in your terminal.  
#                  Else, it will just use "default" AWS profile


# Script Variables
AWS_PAGER=""      # If a pager is available, the script stops waiting to page through output
RED='\033[0;31m'  # Set text Red
NC='\033[0m'      # No text color

########## ##########
########## ##########
# MAIN() 

# Non-Specific Region objects
# IAM
aws sts get-caller-identity
aws iam get-user
aws iam list-groups
aws iam list-roles
#aws iam list-policies

### Route53 Information
echo "## S3 in $REGION"
aws route53 list-hosted-zones

## Region specific objects
header(){  echo "############################# ############################# #############################"; }
footer(){  echo "# --------------------------- ----------------------------- -----------------------------"; }

REGIONS=$(aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text --filters "Name=region-name,Values=us-*")
for REGION in $REGIONS
do 
  header
  echo -e "# Analyzing Region:  ${RED}  $REGION  ${NC}"
  aws configure set region $REGION
  aws configure set output table

  ###  VPC/EC2 Information
  header
  echo "# VPCS in $REGION"
  aws ec2 describe-vpcs --query "Vpcs[].VpcId" 
  aws ec2 describe-vpcs --query 'Vpcs[*].CidrBlock' 
  aws ec2 describe-volumes --output text
  aws ec2 describe-subnets --query 'Subnets[*].[CidrBlock,Tags[?Key==`Name`].Value|[0]]' 
  aws ec2 describe-internet-gateways --query 'InternetGateways[*].Attachments' 
  aws ec2 describe-nat-gateways 
  aws ec2 describe-vpc-endpoints
  aws ec2 describe-addresses 
  # SecurityGroups
  aws ec2 describe-security-groups --query '[Description,GroupId[*],GroupName,VpcId]' 
  aws rds describe-db-security-groups --query 'DBSecurityGroups[*].EC2SecurityGroups[*].EC2SecurityGroupId' 

  # EC2 (and related stuff)
  header
  echo "# EC2 details for $REGION"
  aws ec2 describe-key-pairs --region $REGION
  aws ec2 describe-instances --region $REGION --filters Name=instance-state-name,Values=running

  ### S3 Information for 
  header
  echo "# S3 details in $REGION"
  aws s3 ls 

  ### CloudFormation Information
  header
  echo "# CloudFormation Stacks in $REGION"
  aws cloudformation describe-stacks --query "Stacks[].[StackName,StackStatus]"
  footer
done


exit 0
