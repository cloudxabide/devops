# BASH tricks


## Generate a "random" numeric string
I need to create some random strings to create S3 bucket names.  I (initially) imagined that UUIDgen would have some (native) flag to modify it's output.  Nope.  

The following will work to create an 8 digit numeric value:
```
$ cat /dev/urandom | LC_CTYPE=C tr -dc '0-9' | fold -w 8 | head -n1
$ uuidgen | fold -w 8 | head -1
```
NOTE:  the uuidgen command is actually creating output with hyphens (-) and the fold and head *should* manage this appropriately.  If you were to change the character count to 10 - it would have a '-' in the output.  I don't know whether either approach (dev-urandom vs uuidgen) is a more expensive proposition - but, I figured I would demonstrate both approaches.

## Display the number of days until a specific date (OSX)
So, having a bit of a meh day - let's say, for arguments sake, you wanted to start a new job on Aug 12, 2019 - and... you wanted to give 2 weeks notice.
```
echo $(expr '(' $(date -j -v -14d -f "%Y-%m-%d" "2019-08-12" +%s) - $(date +%s) ')' / 86400) "days until I submit 2-week notice."
46 days until I submit 2-week notice.
```
but.. that would be the Monday before Aug 12 (literally 14 days).  I need to figure out how to do the Friday before.

## Parsing values using sed/awk
The following prints the email addresses from a list, which are contained between < and >
```
$ echo -e "<iamjames@james.com>\n<otherperson@email.com>" > blah1.txt
$ cat blah1.txt | awk -F '[<|>]' '{ print $2 }'
iamjames@james.com
otherperson@email.com
$ 
```

## Run multiple commands after a logic (true/false) statement
This example should be fairly self-explanatory, I believe.  Please note the trailing semi-colon ";" in each stanza.

```
neo:~ jradtke$ [ -f /tmp/file  ] && { echo "/tmp/file already exists"; echo "I repeat: file exists"; } || { echo "creating /tmp/file"; echo "blah" > /tmp/file; echo "file create"; }
creating /tmp/file
file create
neo:~ jradtke$ cat /tmp/file
blah
neo:~ jradtke$ [ -f /tmp/file  ] && { echo "/tmp/file already exists"; echo "I repeat: file exists"; } || { echo "creating /tmp/file"; echo "blah" > /tmp/file; echo "file create"; }
/tmp/file already exists
I repeat: file exists
```

## Add a comment (#) to the beginning of a line in a range 
```
# in vi....
<ESC>
:3,7s/^/# /
```
Will change
```
#!/bin/bash

Status:   Works
Purpose:  Generically display temps that are available via "thermal_zone"
          Mostly just wanted to validate my fan works as expected.
Data:     2020-11-15

```
to 
```
#!/bin/bash
#
# Status:   Works
# Purpose:  Generically display temps that are available via "thermal_zone"
#           Mostly just wanted to validate my fan works as expected.
# Data:     2020-11-15
#
```

## Parsing Input with Options
```
# Select language, optional
declare -A LANGS=(
    [Chinese]=zh_CN
    [English]=EN
    [French]=FR
)

LANG_NAMES=($(echo ${!LANGS[*]} | tr ' ' '\n' | sort -n))

PS3='Please select language #: '
select l in "${LANG_NAMES[@]}"
do
    if [[ -v LANGS[$l] ]]; then
        LANG=$l
        break
    else
        echo 'No such language, try again'
    fi
done < /dev/tty
```

## NOTES:
Some of the tweaks here **may** be Mac specific (i.e. adding LC_CTYPE to the tr command).  I don't know whether they apply to Linux bash without modification.
