# Using AWS CLI

A few more examples of how to use different shell commands to gather and data display 

The following example pulls the ip-ranges.json file from AWS, then runs jq to only display CloudFront IPs in us-east-2 
```
curl -o ip-ranges.json https://ip-ranges.amazonaws.com/ip-ranges.json
jq -r '.prefixes[] | select(.region=="us-east-2") | select(.service=="CLOUDFRONT") | .ip_prefix' < ip-ranges.json
```
**Reference** https://docs.aws.amazon.com/vpc/latest/userguide/aws-ip-ranges.html


This one is pretty bonkers.  First we retrieve a list of ALL services in ALL regions (as far as I know, anyhow)
```
curl -o index.json https://api.regional-table.region-services.aws.a2z.com/index.json
jq '.prices[].attributes."aws:region"' index.json

MY_VIEW_ARN=""
 aws resource-explorer-2 search --region us-west-2 --view-arn="$MY_VIEW_ARN" --query-string 'ec2'
```
