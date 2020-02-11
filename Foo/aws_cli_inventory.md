# AWS CLI Inventory

Rudimentary attempt at codifying a way to gather account inventory (in absence of AWS Config or Cost Explorer)

* EC2
* SecurityGroups
* NACL
* Routes

```
REGION=us-east-2

# IAM
aws iam list-groups
aws iam list-policies

# EC2 (and related stuff)
aws ec2 describe-key-pairs --region $REGION
aws ec2 describe-instances --region $REGION --filters Name=instance-state-name,Values=running
aws ec2 describe-security-groups --region $REGION

# S3
aws s3 ls

aws ec2 describe-vpcs --region $REGION --query 'Vpcs[*].CidrBlock' --output table
aws ec2 describe-subnets --region $REGION --query 'Subnets[*].[CidrBlock,Tags[?Key==`Name`].Value|[0]]' --output table
aws ec2 describe-internet-gateways --region $REGION --query 'InternetGateways[*].Attachments'

## THIS STILL NEEDS WORK
aws ec2 describe-images --region $REGION  --filter "Name=is-public,Values=false" \
    --query 'Images[].[ImageId, Name]' \
    --output text | sort -k2
```

