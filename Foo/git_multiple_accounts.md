# Using Git with multiple accounts

STATUS:  I am still working through this.  I think I have the "SSH key" issue sorted, and now have a quick way to update the remote url.  I believe I'll be messing with "global config" and defaults next.

I had been (generally) only using one github account until recently.  Almost all of my "development" was done in my homelab and for stuff that only I would be interested in, or using.  Any "work stuff" to this point was committed and pushed to an internal git instance.  That all changed, and now I, too, have to change.


## General Information
git username (Personal): cloudxabide
git username (Work): JamesRadtke-RedHat

### How I layout my Git Repos
I create a directory for all my git repos aptly named "${HOME}/Repositories".  In there I create a separate directory each $GITUSER
```
Repositories/
├── cloudxabide
│   ├── ansible
│   ├── aperture.lab
├── JamesRadtke-RedHat
│   ├── crash-sinatra
│   ├── hattrick
│   ├── healthcheck-https
```

## Create separate SSH keys for each user

```
ssh-keygen -trsa -b2048 -C "username@redhat.com" -f ~/.ssh/id_rsa-github-JamesRadtke-RedHat
ssh-keygen -tecdsa -b521 -C "cloudxabide@gmail.com" -f ~/.ssh/id_ecdsa-github-cloudxabide
ssh-keygen -tecdsa -b521 -C "$USER@$HOSTNAME" -f ~/.ssh/id_ecdsa-github-cloudxabide
```

## Update SSH config
NOTE:  This ASSUMES you have not setup your ~/.ssh/config  
  (but, I *did* make it not overwrite the file - just in case you don't understand what the following command is about to do)
```
touch ~/.ssh/config; chmod 0600 $_

cat << EOF >> ~/.ssh/config
# Github Foo
Host github.com-JamesRadtke-RedHat
  Hostname github.com
  User git
  IdentityFile ~/.ssh/id_rsa-github-JamesRadtke-RedHat
Host github.com-cloudxabide
  Hostname github.com
  User git
  IdentityFile ~/.ssh/id_rsa-github-cloudxabide
# I think it is best to leave this one last in the list
Host github.com
  Hostname github.com
  User git
  IdentityFile ~/.ssh/id_rsa-github-cloudxabide
EOF
```

## Update to existing 
Since I had created many of my "work repos" quite some time ago, using who-knows-what key to do so, I had to update the origin url to use ssh and a URL that would be recognized by my ~/.ssh/config and invoke tehe correct parameters.

```
GITUSER="JamesRadtke-RedHat"
cd $HOME/Repositories/Personal/$GITUSER
for DIR in `ls`; do cd $DIR; git remote set-url origin "ssh://github.com-${GITUSER}/${GITUSER}/$(basename `pwd`).git";  cd -; done
```
