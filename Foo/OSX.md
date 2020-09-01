# OSX tips-and-tricks

## Extended File Attributes
Somehow I had managed to apply (and mess up) extended file attributes to my ~/Music directory and that wreaked havoc with my Music collection.

```
# Set VAR for Directory to fix
DIR=~/Music
MYUSER=$(whoami)

# Show all extended attributes
ls -lOe $DIR
 
# Remove no-change attributes
sudo chflags nouchg $DIR

# Recursively clear all entended attributes
sudo xattr -rc $DIR 
 
# The reset to rational owner & perms
sudo chown -R username:staff $DIR
sudo chmod -R 0700 $DIR
```
