# AWS Account Management

## AWS Control Tower (fka, Automated Landing Zone, sort of)
So, I am opting to use AWS Control Tower to deploy a "multi-account" environment.  Automated Landing Zone (AWS ALZ) was pretty cool and Control Tower is essentially the successor to ALZ.

Your landing zone is being set up
AWS Control Tower is setting up the following:

* 2 organizational units, one for your shared accounts and one for accounts that will be provisioned by your users.
* 3 shared accounts, which are the master account and isolated accounts for log archive and security audit.
* A native cloud directory with preconfigured groups and single sign-on access.
* 20 preventive guardrails to enforce policies and 2 detective guardrails to detect configuration violations.


## Separation of Duties

There are some "legacy" principles that I still subscribe to is:  [Seperation of Duties](https://en.wikipedia.org/wiki/Separation_of_duties).  My outlook typically causes people to get pretty uptight and argumentative.  

"Separation of duties is commonly used in large IT organizations so that no single person is in a position to introduce fraudulent or malicious code or data without detection."

Arguments against SoD:  
* It *slows down* development and releases
* There will *still* be situations where several people will be nefarious

Anyhow, that is not what the intent of this page is.

| Scope     | contact                        | Purpose         |
|:----------|:-------------------------------|:----------------|
| Admin     | \<email>+master@domain.com     | Overall management of the account (break-glass access)
| Network   | \<email>+networking@email.com  | Manage Account-Level Network functions
| Logging   | \<email>+log-archive@email.com | Account-level logging management
| Security  | \<email>+security@email.com    | Account-level security management



## Examples 
* Site-to-Site VPN stops working, developer modifies the BGP and network params.  Hairpins all the egress traffic from the CORP prem and brings the place to a crawl - amassing serious network charges in the process.
* Developer would like to use new functions available in the newest version of PHP.  Since the versions available in the standard repos are a bit dated, they add a 3rd-party repo - causing package conflicts (now hosts can't be patched) and adding security risk using packages not "vetted" or idemnified.
* Developer is struggling to get new functionality working with FIPS - so, they go and find non-FIPS enabled images.  Company is now at-risk of fines/penalties.
