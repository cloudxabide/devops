# boto3 to query S3

it is implied that you have a valid/active AWS_DEFAULT_PROFILE=

## List Existing Buckets
```
# Retrieve the list of existing buckets
s3 = boto3.client('s3')
response = s3.list_buckets()

# Output the bucket names
print('Existing buckets:')
for bucket in response['Buckets']:
    print(f'  {bucket["Name"]}')
```

