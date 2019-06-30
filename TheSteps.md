# The Steps

## Discussion
Working backwards, let's discuss the end goals:
* There will be (or... should be) no impact to the existing SAP environment, until we have tested TGW and Route 53 and are ready to roll SAP in
* Route 53 resolver operational for all accounts to provide AWS and on-prem DNS
* Transit Gateway providing a hub-and-spoke network model to provide connectivity between all vended (and core) accounts, as well as the on-prem environment.
 * site-to-site VPN 
 * Direct Connect (which currenlty is only supported via Public Host VIF)
* Integrate the SAP environment which is in the ALZ with the rest of the network to include TGW and Route 53.

Until there is *some* sort of connectivity back to on-prem, there is not a path forward to configure Route 53 Resolver that won't introduce more work and risk later to undo/redo that implementation.

## Step

There are several steps that are order-dependent

* Create the Transit Gateway in the Networking Account
* Create the Site-To-Site VPN connection
* Deploy a Windows AD Server (or several) in a Shared Services Priv AZ
* vend 2 accounts for testing the TGW connectivity (between accounts and on-prem)A
* Create TGW shares to the Shared Services and 2 new vended accounts
 * Accept the share in each account
* Create Route 53 Resolver Outbuond Enpoints (you only need Inbound if you are planning on pointing your on-prm resources to them)
* configure Route 53 Resolver rules (similar to what Syed did in POC) in Shared Services account
* Create share for the r53 Resolver rules to the accounts currently available that will use the rules (do not include the SAP LOB account though)  NOTE:  you can share right from the r53 rules console (it will take you to Resource Access Manager)
 * Accept the share in each account which you shared to

