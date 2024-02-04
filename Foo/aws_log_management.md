# AWS Log Management

Delete ALL the logs
```
REGION="us-east-1"
aws logs describe-log-groups --query 'logGroups[*].logGroupName' --region $REGION --output table | awk '{print $2}' | grep -v ^$ | while read x; do aws logs delete-log-group --log-group-name $x --region $REGION ; done
```
