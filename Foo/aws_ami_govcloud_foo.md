# AWS AMI GovCloud foo

Status:   Work in Progress
Purpose:  Provide guidance/advice for working with GovCloud with images instantiated in Commercial
Date:     2020-11-22

NOTES:    I guess I don't understand enough about GovCloud to understand why this is even necessary.  
          Specifically, why can't an AMI be published in GovCloud the same way it is in Commercial.

## Manage AMI in GovCloud

### Import Commerical image in GovCloud
A few things legitimize this Git Repo as an AWS resource  
https://github.com/awslabs/aws-gov-cloud-import
* awslabs is an official Git Repo
* The user doing the dema has "ANT / blah" for a username (easy enough to mimic, but why would you)

I think what "awsjason" has created is pretty tremendous.  That said, it's not for everyone.
If you have a significant team of people with accounts in your GovCloud environment (which is typical),
there are some facets to consider: 
* the vmimport role must not exist
* (well, that's it so far)
