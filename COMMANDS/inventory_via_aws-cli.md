# Inventory AWS resources
REGIONS=$(aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text --filters "Name=region-name,Values=us-*")
for REGION in $REGIONS
do 
  echo "#############################"
  echo "# Analyzing Region:  $REGION"
  aws configure set region $REGION
  aws ec2 describe-vpcs --query "Vpcs[].VpcId"
  aws cloudformation describe-stacks --query "Stacks[].StackName"
  #aws ec2 describe-vpc-attribute
  #aws ec2 describe-volumes
done

