# BASH tricks


## Generate a "random" numeric string
I need to create some random strings to create S3 bucket names.  I (initially) imagined that UUIDgen would have some flag to modify it's output.  Nope.  

The following will work to create an 8 digit numeric value:
```
$ cat /dev/urandom | LC_CTYPE=C tr -dc '0-9' | fold -w 8 | head -n1
$ uuidgen | fold -w 8 | head -1
```
NOTE:  the uuidgen command is actually creating output with hypens (-) and the fold and head *should* manage this appropriately.  If you were to change the character count to 10 - it would have a '-' in the output.  I don't know whether either approach (dev-urandom vs uuidgen) is a more expensive proposition - but, I figured I would demonstrate both approaches.

## NOTES:
Some of the tweaks here **may** be Mac specific (i.e. adding LC_CTYPE to the tr command).  I don't know whether they apply to Linux bash without modification.
