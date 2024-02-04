# Check File Integrity

Status:  work in progress

Using OpenDKIM as an example
```
mkdir ~/opendkim
cd $_

FILES="
opendkim-2.10.3.tar.gz
opendkim-2.10.3.tar.gz.asc
opendkim-2.10.3.tar.gz.md5
opendkim-2.10.3.tar.gz.sha1"

for FILE in $FILES
do
  curl -L -o $FILE https://sourceforge.net/projects/opendkim/files/$FILE/download
  file $FILE
done

md5sum opendkim-2.10.3.tar.gz
cat opendkim-2.10.3.tar.gz.md5

RETRIEVED_MD5=$(md5sum opendkim-2.10.3.tar.gz | awk '{ print $1 }')
EXPECTED_MD5=$(cat opendkim-2.10.3.tar.gz.md5 | cut -f2 -d\= | sed 's/\ //g')
if [ $RETRIEVED_MD5 != $EXPECTED_MD5 ]; then  echo "ERROR: you shall not pass"; fi

# To test that actually works, change one of the values
EXPECTED_MD5=bobsyouruncle
if [ $RETRIEVED_MD5 != $EXPECTED_MD5 ]; then  echo "ERROR: you shall not pass"; fi

# You can do the same using SHA1
sha1sum  opendkim-2.10.3.tar.gz
cat opendkim-2.10.3.tar.gz.sha1

# Using GPG (and the *asc file) is a bit more involved
```
