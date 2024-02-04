#!/bin/bash
#
#     Purpose: This script should run on a host that is behind my NAT Gateway at home to update route53.
#      Author: jaradtke@ridexabide.com
#        Date: 2019-02-15
#      Status: Tested, not production though.  Seems to work but would like to test more.
#       Notes: There better ways of accomplishing this.  But, this gets it done.
#
# Assumptions: The AWS CLI is installed and there is a ~/.aws/config and ~/.aws/credentials with a
#                user that matches AWS_PROFILE value.
#              The AWS_PROFILE is attached to an IAM user with Policy:AmazonRoute53FullAccess
#              This script is run from a host *behind* my home router/firewall.
#
#     Issues:  Well, this is interesting.  Say you want to add "www.host.com" - but... you already have *.host.com = the script 
#                goes to lookup www.host.com and gets a responsse (from the wildcard).  Ugh.

usage() {
  echo "ERROR:"
  echo "$0 <domain>.<tld>"
  echo "$0 <domain>.<tld> <host> (optional)"
  exit 9
}

# PARAMETERS/VARIABLES
if [ $# -lt 1 ]; then usage; fi 

DOMAIN=${1}

if [ -z "$2" ]
then 
  RECORDSET="${DOMAIN}"
else
  echo "2 parameters recognized"
  HOST="$2"
  RECORDSET="${HOST}.${DOMAIN}"
 fi

OUTPUT=/tmp/update_route53-${RECORDSET}.out

AWS_CMD=${HOME}/.local/bin/aws
AWS_PROFILE="rxa-route53"
export AWS_DEFAULT_PROFILE="$AWS_PROFILE"

TTL=3600
TYPE=A
UPDATECOMMENT="Update to record `date +%F`"

exec > $OUTPUT 2>&1

# QUERY FOR INPUTS
HOSTZONEID=$(${AWS_CMD} route53 --query "HostedZones[*].Id" --output text list-hosted-zones-by-name --dns-name ${DOMAIN} --max-items 1)
#MYIP=$(curl -s ifconfig.co)
MYIP=$(curl -s http://checkip.amazonaws.com/)
HOSTIP=$(dig +short "${RECORDSET}" @8.8.8.8)

export AWS_DEFAULT_PROFILE=${AWS_PROFILE}
# export AWS_DEFAULT_OUTPUT="table"

# REPORTING
echo "Domain:       $DOMAIN"
echo "Host entry:   $RECORDSET"
echo "HostZone ID:  $HOSTZONEID"
echo "My IP:        $MYIP"
echo "DNS IP:       $HOSTIP"

# COMPARISON
if [ "$MYIP" == "$HOSTIP" ]
then
  echo "DNS does not need to be updated.  Exiting here."
  exit 0
else
  echo
  echo "DNS IP needs to be updated $MYIP != $HOSTIP"

ROUTE53template=$(mktemp)
echo "Route53 template is located at: $ROUTE53template"
cat << EOF > ${ROUTE53template}
{
  "Comment":"$UPDATECOMMENT",
  "Changes":[
    {
      "Action":"UPSERT",
      "ResourceRecordSet":{
        "ResourceRecords":[
          {
            "Value":"$MYIP"
          }
        ],
        "Name":"$RECORDSET",
        "Type":"$TYPE",
        "TTL":$TTL
      }
    }
  ]
}
EOF
fi

# MAKE SURE TEMPLATE HAS BEEN CREATED
if [ -f $ROUTE53template ]
then
  echo "Update Template Found"
  echo "aws route53 change-resource-record-sets --hosted-zone-id $HOSTZONEID --change-batch file:/\"$ROUTE53template\" "
  ${AWS_CMD} route53 change-resource-record-sets --hosted-zone-id $HOSTZONEID --change-batch file://"$ROUTE53template"
fi

# CLEANUP
echo "NOTE: Here is the template file"
cat $ROUTE53template

echo "Clean up temp file"
rm $ROUTE53template

exit 0
