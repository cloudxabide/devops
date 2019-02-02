## Install the AWS cli components - demonstrated in [./OSX.sh](OSX.sh#Install-AWS-CLI)

## Create a "credentials" file (~/.aws/credentials)
\# aws configure

-- Modify the file to include additional users and credentials

```
[default]
aws_access_key_id = ACCESSKEYIDHERE 
aws_secret_access_key = SECRETACCESSKEYHERE

[cXa-jaradtke]
aws_access_key_id = ACCESSKEYIDHERE
aws_secret_access_key = SECRETACCESSKEYHERE
```

-- Then create a "profile" (~/.aws/config)
```
[default]
region=us-east-2
output=json

[profile cXa-jaradtke]
region=us-east-2
output=text
```

-- To utilize the configuration from the command line...  

```
mylaptop:~ jaradtke$ export AWS_PROFILE=cXa-jaradtke
mylaptop:~ jaradtke$ aws ec2 describe-regions --filters "Name=endpoint,Values=*us*"
REGIONS    ec2.us-east-1.amazonaws.com    us-east-1
REGIONS    ec2.us-east-2.amazonaws.com    us-east-2
REGIONS    ec2.us-west-1.amazonaws.com    us-west-1
REGIONS    ec2.us-west-2.amazonaws.com    us-west-2
mylaptop:~ jaradtke$ aws ec2 describe-instances --profile cXa-jaradtke --filters "Name=endpoint,Values=*us*"
```


