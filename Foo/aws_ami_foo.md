# AWS AMI Foo

Working with AMIs can be a bit challenging for folks who are using AMIs from a specific vendor and/or when using Commercial vs GovCloud.

* ami_owner_redhat_commercial = 309956199498
* ami_owner_redhat_govcloud   = 219670896067
* ami_owner_redhat_coreos     = 531415883065

I have preconfigured credentials for each of my environments:  
Here is an example of how things are different between Comm and GovCloud

```
query_for_AMIs() {
OWNERS="309956199498 219670896067 531415883065"
for OWNER in $OWNERS
do 
  echo "Owner: $OWNER - RHEL-8.2*"
  aws ec2 describe-images --query 'length(Images[].Name)' --owners $OWNER \
    --filter Name=name,Values="RHEL-8.2*"
  echo "Owner: $OWNER - rhcos-46*"
  ## How many can we find (given the filter)
  aws ec2 describe-images --query 'length(Images[].Name)' --owners $OWNER \
    --filters "Name=name,Values=rhcos-46*"
  aws ec2 describe-images --query 'sort_by(Images, &CreationDate)[].Name' \
    --owners $AMI_OWNER --filters "Name=name,Values=rhcos-46*"
done
}

echo "Using Commercial Credentials"
export AWS_DEFAULT_PROFILE="ciol-jradtke" 
query_for_AMIs

echo "Using GovCloud Credentials"
export AWS_DEFAULT_PROFILE=jradtke-admin # GovCloud
query_for_AMIs

```

Output:
```
Using Commercial Credentials
Owner: 309956199498 - RHEL-8.2*
15
Owner: 309956199498 - rhcos-46*
0
Owner: 219670896067 - RHEL-8.2*
0
Owner: 219670896067 - rhcos-46*
0
Owner: 531415883065 - RHEL-8.2*
0
Owner: 531415883065 - rhcos-46*
256
Using GovCloud Credentials
Owner: 309956199498 - RHEL-8.2*
0
Owner: 309956199498 - rhcos-46*
0
Owner: 219670896067 - RHEL-8.2*
5
Owner: 219670896067 - rhcos-46*
0
Owner: 531415883065 - RHEL-8.2*
0
Owner: 531415883065 - rhcos-46*
0
```

## The takeaways:
| Credentials | Commerical <BR> RHEL-8.2* | GovCloud <BR> RHEL-8.2* | RH CoreOS <BR> rhcos-46*|
|:-----------:|:----------:|:--------:|:---------:|
| Commerical  |     Y      |    N     |    Y      |
| GovCloud    |     N      |    Y     |    N      |


* while connecting using my Commercial credentials 
  * I could retrieve info for RHEL-8.2* and rhcos-46* (Commerical and Red Hat CoreOS)
  * I could NOT retrieve info any AMI (Red Hat GovCloud)
* while connecting using my GovCloud credentials
  * I could retrieve info for RHEL-8.2* 
  * I could not retrieve RHEL-8.2* nor rhcos-46* (Commerical and Red Hat CoreOS)

## Just give the AMI
Fine! If you are just looking for an AMI for whatever you are doing, you can just do the following:
NOTE: This *should* return all 8.2* HVM x86_64 images which are not BETA
```
for REGION in $(aws ec2 describe-regions --query Regions[].RegionName --output text)
do 
  aws ec2 describe-images --owners 309956199498 --filters "Name=name,Values=RHEL-8.2*HVM-2*x86_64*"  --query "sort_by(Images, &CreationDate)[*].[Name,ImageId]" --region $REGION
done
```
Or.. hammer through by hand
```
aws ec2 describe-images --owners 531415883065 --filters "Name=name,Values=rhcos-46*"  --query "sort_by(Images, &CreationDate)[*].[Name,ImageId]" --region $REGION
```

