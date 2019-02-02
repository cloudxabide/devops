
## Install the AWS cli components


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

