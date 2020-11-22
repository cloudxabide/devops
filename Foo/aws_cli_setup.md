# AWS Cli Setup (and usage)
## Overview

I am concluding that while you can invoke specific profiles several different ways (ENV Variable, configuration files, within a script itself) I believe it makes sense to define your configuration using files, and then reference those files.  My view may potentially change on this.

Also, this explanation is predicated on the idea that you have already created several different IAM user accounts (different Organizations, different Roles, etc...)
## Steps
### Install the AWS cli components (see [../Scripts/OSX.sh](../Scripts/OSX.sh))

### Create a "credentials" file (~/.aws/credentials)
```
$ aws configure
```

-- Modify the file to include additional users and credentials

```
[default]
# I leave this empty on purpose
#   it "forces" you to select a profile first

[cxa-jaradtke]
aws_access_key_id = ACCESSKEYIDHERE
aws_secret_access_key = SECRETACCESSKEYHERE
```
### Create a "config" file (~/.aws/config)

```
[default]
region=us-east-1
output=json

[profile cxa-jaradtke]
region=us-east-2
output=text
```
### CLI examples
-- To utilize the configuration from the command line...  

```
$ export AWS_DEFAULT_PROFILE="cxa-jaradtke"
$ aws ec2 describe-regions --filters "Name=endpoint,Values=*us*"
{
    "Regions": [
        {
            "Endpoint": "ec2.us-east-1.amazonaws.com",
            "RegionName": "us-east-1"
        },
        {
            "Endpoint": "ec2.us-east-2.amazonaws.com",
            "RegionName": "us-east-2"
        },
        {
            "Endpoint": "ec2.us-west-1.amazonaws.com",
            "RegionName": "us-west-1"
        },
        {
            "Endpoint": "ec2.us-west-2.amazonaws.com",
            "RegionName": "us-west-2"
        }
    ]
}
$ aws ec2 describe-regions --profile "cxa-jaradtke" --filters "Name=endpoint,Values=*us*"
REGIONS    ec2.us-east-1.amazonaws.com    us-east-1
REGIONS    ec2.us-east-2.amazonaws.com    us-east-2
REGIONS    ec2.us-west-1.amazonaws.com    us-west-1
REGIONS    ec2.us-west-2.amazonaws.com    us-west-2
```

```
$ aws ec2 describe-vpcs --query "Vpcs[].VpcId"
$ aws cloudformation describe-stacks --query "Stacks[].StackName"
``` 

### Scripting
-- To utilize the configuration from a python script...  
```
import boto
con = boto.connect_s3()
```


```
import boto
con = boto.connect_s3(profile_name="cxa-jaradtke")
```
