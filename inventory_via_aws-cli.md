# Inventory AWS resources

for REGION in $(aws ec2 describe-regions --query "Regions[].{Name:RegionName}" --output text --filters "Name=region-name,Values=us-*")
do 
  aws configure set region $REGION
  #aws ec2 describe-availability-zones
done

