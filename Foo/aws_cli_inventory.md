# Inventory via AWS CLI
This (ultimately) should provide the commands to inventory all the AWS resources we can query.

STATUS:  Work in Progress
         Executable without issue


Rudimentary attempt at codifying a way to gather account inventory (in absence of AWS Config or Cost Explorer)

* EC2
* SecurityGroups
* NACL
* Routes

## Quick and Dirty
If you want to run *my* simple inventory, do the following
```
bash <(curl -s https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Scripts/aws_cli_inventory.sh)
```
or...
```
export AWS_DEFAULT_PROFILE="profile_name"
MYDATE=`date +%F-%H-%M`
TMPDIR=$(mktemp -d) 
OUTPUT="${TMPDIR}/aws_cli_inventory-${MYDATE}.out"
cd $TMPDIR || exit 1
wget https://raw.githubusercontent.com/cloudxabide/devops/HEAD/Scripts/aws_cli_inventory.sh
chmod a+x aws_cli_inventory.sh
echo "output at: ${OUTPUT}"
./aws_cli_inventory.sh > $OUTPUT
cd -
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
