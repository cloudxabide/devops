wget https://access.redhat.com/documentation/en-us/openshift_container_platform/3.9/
wget `grep 'pdf"' index.html | cut -f2 -d\" | awk '{ print "https://access.redhat.com/" $1 }'`

exit 0
# https://access.redhat.com/documentation/en-us/openshift_container_platform/3.9/pdf/release_notes/release-notes.pdf
