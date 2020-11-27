# Inventory via AWS CLI
This (ultimately) should provide the commands to inventory all the AWS resources we can query.

STATUS:  Work in Progress
         Executable without issue


Rudimentary attempt at codifying a way to gather account inventory (in absence of AWS Config or Cost Explorer)

* EC2
* SecurityGroups
* NACL
* Routes

## Non-Region specific objects
```
# IAM
aws iam list-groups
aws iam list-policies

### Route53 Information
echo "## S3 in $REGION"
aws route53 list-hosted-zones
```

## Region specific objects
```
header(){  echo "############################# ############################# #############################"; }
footer(){  echo "############################# ############################# #############################"; }
RED='\033[0;31m'
NC='\033[0m' # No Color

REGIONS=$(aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text --filters "Name=region-name,Values=us-*")
for REGION in $REGIONS
do 
  header
  echo "# Analyzing Region:  ${RED} $REGION ${NC}"
  aws configure set region $REGION
  aws configure set output table

  ###  VPC/EC2 Information
  header
  echo "# VPCS in $REGION"
  aws ec2 describe-vpcs --query "Vpcs[].VpcId" 
  aws ec2 describe-vpcs --query 'Vpcs[*].CidrBlock' 
  aws ec2 describe-volumes 
  aws ec2 describe-subnets --query 'Subnets[*].[CidrBlock,Tags[?Key==`Name`].Value|[0]]' 
  aws ec2 describe-internet-gateways --query 'InternetGateways[*].Attachments' 
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
```

### Other Example queries
```
aws ec2 describe-instances --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, IP: PublicIpAddress, ImageId: ImageId, TIme: LaunchTime}" --output table --color off

aws ec2 describe-instances --query Reservations[].Instances[].[[Tags[*].Value],PublicIpAddress,ImageId,InstanceId,LaunchTime]

# Search for the Red Hat CoreOS Images
aws ec2 describe-images --owners 531415883065 --filters "Name=name,Values=rhcos-46*"  --query "sort_by(Images, &CreationDate)[*].[Name,ImageId]"
```

## NOTES
## THIS STILL NEEDS WORK
```
aws ec2 describe-images --region $REGION  --filter "Name=is-public,Values=false" \
    --query 'Images[].[ImageId, Name]' \
    --output text | sort -k2

## Show all AMI for a particular "owner" with "RHEL-8.2_HVM-*x86_64*" in the Name
for REGION in $(aws ec2 describe-regions --query Regions[].RegionName --output text); do aws ec2 describe-images --owners  219670896067 --region $REGION --query 'sort_by(Images, &CreationDate)[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=RHEL-8.2_HVM-*x86_64*" --output text; done
#variable "rhel8-ami" {
#  type      = string
#  default   = "ami-08e923f2f38197e46"
#}
```
