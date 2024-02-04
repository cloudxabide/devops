#!/bin/bash
# $Id$
#  I'm lazy and want to pull down ALL the docs for a particular Red Hat
#    product so I can have on my tablet/PC as a reference
# 
#  Leave this file in the "base directory" and cd to the product you want to update
#    mkdir -p "${HOME}/Documents/Product Docs/Red Hat/"
#    cd "${HOME}/Documents/Product Docs/Red Hat/"
#    cp grab_docs.sh .
#    mkdir "OpenShift Container Platform"
#    cd "OpenShift Container Platform"; cat .info; sh ../grab_docs.sh


# Make sure the .info Configuration File exists and then source it
[ -f .info ] && . ./.info || { echo "Create .info Configuration file"; exit 9; } 

mkdir $VERSION; cd $_
[ -f ./index.html ] && rm ./index.html
# This is a weird situation where the version number IS the page name (i.e. NOT index.html, but rather 2.4)
wget "${PRODUCT_URL}/${VERSION}" -O index.html

for URL in ` grep 'pdf"' index.html | cut -f2 -d\" | awk '{ print "https://access.redhat.com/" $1 }'`
do
  FILENAME=`echo $URL | sed 's:.*/::'`
  echo "$FILENAME - $URL"
  [ ! -f $FILENAME ] && wget $URL
done

cd - 

exit 0
