# AWS Housekeeping

Some "default" things I will generally do, and not do very often (so, I'll forget)

## Search for AWS ACCESS KEY/ACCESS KEY ID in your files
```
cd $REPOSITORY
grep -RP '(?<![A-Z0-9])[A-Z0-9]{20}(?![A-Z0-9])' *
grep -RP '(?<![A-Za-z0-9/+=])[A-Za-z0-9/+=]{40}(?![A-Za-z0-9/+=])' *
```

I'm not a huge fan of entering my AWS KEY/SECRET as a ENV variable (mostly because it ends up in .bash_history)

So - this is some security-through-obscurity and *should* be managed via aws-vault
Additionally, this whole process expects a fairly well-formed "credentials" and "config" file

```
${HOME}/.aws/credentials
[profile_name]
aws_access_key_id = XXYYZZ
aws_secret_access_key = AABBCC

${HOME}/.aws/config
[profile_name]
default_region = us-east-1
```

## Setup your Environment
```
AWS_CREDENTIALS="${HOME}/.aws/credentials"
AWS_CONFIG="${HOME}/.aws/config"
export AWS_DEFAULT_PROFILE="ciol-jradtke"
export aws_access_key_id=$(grep -A3 $AWS_DEFAULT_PROFILE ${AWS_CREDENTIALS}| grep aws_access_key_id | awk -F\= '{ print $2 }' | sed 's/ //g')
export aws_secret_access_key=$(grep -A3 $AWS_DEFAULT_PROFILE ${AWS_CREDENTIALS} | grep aws_secret_access_key | awk -F\= '{ print $2 }' | sed 's/ //g')
export default_region=$(grep -A2 $AWS_DEFAULT_PROFILE ${AWS_CONFIG} | grep default_region | awk -F\= '{ print $2 }' | sed 's/ //g')
echo "$AWS_DEFAULT_PROFILE $aws_access_key_id $aws_secret_access_key $default_region"
```

## Opt-out of non-US regions
TODO:  this ^^^

## Removing the default VPC (this is not really necessary)
# Get the Vpc-Id for the Default VPC
```
VPCID=$(aws ec2 describe-vpcs --region $default_region --filter Name=isDefault,Values=true --query Vpcs[].VpcId --output text)
```

# STOP if the VPCID was not found
```
[ -z $VPCID ] && { echo "yo, there's no defaut VPC in this region.  Exit in 5"; sleep 5; exit 0; }
```

# Retrieve the Internet Gateways associated/attached to the Default VPC, then detach/delete them
```
for IGWID in $(aws ec2 describe-internet-gateways --region $default_region --filter Name=attachment.vpc-id,Values=${VPCID} --query InternetGateways[].InternetGatewayId --output text)
do
  echo "aws ec2 detach-internet-gateway --region $default_region --internet-gateway-id $IGWID --vpc-id ${VPCID}"
  aws ec2 detach-internet-gateway --region $default_region --internet-gateway-id $IGWID --vpc-id ${VPCID}
  echo "aws ec2 delete-internet-gateway --region $default_region --internet-gateway-id $IGWID"
  aws ec2 delete-internet-gateway --region $default_region --internet-gateway-id $IGWID
done

# Now retreive the Subnets associated with the default VPC, then delete them
for SUBNETID in $(aws ec2 describe-subnets --region $default_region --filters Name=vpc-id,Values=${VPCID} --query Subnets[].SubnetId --output text)
do
  aws ec2 delete-subnet --region $default_region --subnet-id $SUBNETID
done

aws ec2 delete-vpc --region $default_region --vpc-id ${VPCID}
```

## Create a Default VPC
And.. to put it all back
```
aws ec2 create-default-vpc --region $default_region
```
