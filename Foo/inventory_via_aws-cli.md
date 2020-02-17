# Inventory via AWS CLI
This (ultimately) should provide the commands to inventory all the AWS resources we can query.

STATUS:  Work in Progress
         Executable without issue

## AWS CLI commands
```

 
REGIONS=$(aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text --filters "Name=region-name,Values=us-*")
for REGION in $REGIONS
do 
  echo "#############################"
  echo "# Analyzing Region:  $REGION"
  aws configure set region $REGION
  aws configure set output table

  ###  VPC/EC2 Information
  echo "## VPCS in $REGION"
  aws ec2 describe-vpcs --query "Vpcs[].VpcId" 
  aws ec2 describe-vpcs --query 'Vpcs[*].CidrBlock' 
  aws ec2 describe-subnets --query 'Subnets[*].[CidrBlock,Tags[?Key==`Name`].Value|[0]]' 
  aws ec2 describe-internet-gateways --query 'InternetGateways[*].Attachments' 
  aws ec2 describe-volumes 

  ### S3 Information for 
  echo "## S3 in $REGION"
  aws s3 ls 

  ### CloudFormation Information
  echo "## CFN Stacks"
  aws cloudformation describe-stacks --query "Stacks[].[StackName,StackStatus]"
  echo "############################# ############################# #############################"
  echo ""
done

# Non-Regional Resources
### Route53 Information
echo "## S3 in $REGION"
aws route53 list-hosted-zones 



```


### Other Example queries
```
aws ec2 describe-instances --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, IP: PublicIpAddress, ImageId: ImageId, TIme: LaunchTime}" --output table --color off

aws ec2 describe-instances --query Reservations[].Instances[].[[Tags[*].Value],PublicIpAddress,ImageId,InstanceId,LaunchTime]
```
