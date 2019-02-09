# Rotate Your Access Keys

Work in Progress - Incomplete

## Summary
There are several best-practices that should be followed regarding security of your account.  MFA, delete root account, etc... 

You should also rotate your Access Keys - and it is actually quite simple.

```
USER="cxa-testuser1"
aws iam create-user --user-name $USER
AK1=$(mktemp -t AK1-$USER)
aws iam create-access-key \
  --user-name $USER \
  --output text | tee $AK1 
aws iam list-access-keys --user-name $USER
EXISTING_AK=$(aws iam list-access-keys --user-name $USER --output text --query "AccessKeyMetadata[].{Name:AccessKeyId}")
AK2=$(mktemp -t AK2-$USER)
aws iam  create-access-key \
  --user-name $USER \
  --output text | tee $AK2
aws iam update-access-key \
    --access-key-id $EXISTING_AK \
    --status Inactive \
    --user-name $USER
aws iam delete-access-key \
    --access-key-id $EXISTING_AK \
    --user-name $USER
aws iam list-access-keys --user-name $USER
echo "Retrieve new key info from: $AK2"
echo "Then run the following command:"
echo "cat /dev/null > $AK2"
echo "rm $AK2""
```


## References:
https://aws.amazon.com/blogs/security/how-to-rotate-access-keys-for-iam-users/
