# GIT Cheatsheet

## Clone ALL of my public repos (private requires an API key)
It is expected that you already have your SSH key configured for each GIT repo(user) you're about to clone.  
```
cd
for USER in cloudxabide ridexabide jradtke-rh
do
  mkdir -p ~/Repositories/$USER; cd $_
  for REPO in $(curl -s https://api.github.com/users/$USER/repos | grep "ssh_url" | awk '{ print $2 }' | sed 's/,//g' | sed 's/"//g')
  do
    git clone $REPO
  done
  cd -
done
```

Or... let's say you want to grab all the (public) repos for a user (OpenShiftDemos)  

```
for REPO in $(curl -s https://api.github.com/users/OpenShiftDemos/repos | grep "clone_url"  | awk '{ print $2 }' | sed 's/,//g' | sed 's/"//g')
do
  git clone $REPO
done
```

Want to see what files have been modified recently (like the past 2 days?)
```
git log --name-status --since="2 days ago" 
git log --pretty=format: --name-only --since="2 days ago"
```

## GIT ENV Management
mkdir ~/.git/

## GIT IGNORE 
https://help.github.com/en/github/using-git/ignoring-files
NOTE:  *You* may not want to exclude all of the following, I exclude them for... reasons...
```
GLOBAL_GITIGNORE=~/.gitignore_global
# Tweak GIT ignores - ignore files in your repo
echo ".DS_Store" >> $GLOBAL_GITIGNORE
echo ".gitignore" >> $GLOBAL_GITIGNORE
echo ".gitconfig" >> $GLOBAL_GITIGNORE
echo ".terraform" >> $GLOBAL_GITIGNORE
echo "terraform.tfstate*" >> $GLOBAL_GITIGNORE

git config --global core.excludesfile $GLOBAL_GITIGNORE
```

## .gitignore seems to be ignored...
I had found myself in a place where no matter how I updated my .gitignore, certain files were still being analyzed and then reported against.  After some research I learned it was because I had told git to track them, prior to updating my ./.gitignore and therefore git still "knew" about the files.  

### Cleanup 
Manually cleanup the things that *you know* need to be commited, pushed, etc... then run:  
```
git rm -r --cached .
git add .
git commit -m "fixed untracked files"
```

## Markdown examples

### Blockquote

\> NOTE:  Here is a blockquote  
> NOTE:  Here is a blockquote  

### Indent Spacing  

\<space x 4\>\**\_NOTE:\_**  Here is a "double tab" with Emphasis '_' and Bold '**'  

    **_NOTE:_**  Here is a "double tab"

### Code Documentation
\```  
Your code  
goes here  
\```  

```
Your code
goes here
```

### Quick branch/checkout/push
```
branchname="`whoami`-`date +%F-%H-%M-%S`"
git checkout -b $branchname
git add <changed files>
git commit -m "My comment" <changed file>
git push --set-upstream origin $branchname
git push
```


### Git rec'd process
-- this still needs tweaking
```
MYBRANCH="`whoami`-`date +%F-%H%M%S`"
git checkout master

#### Step 1. Fetch and check out the branch for this merge request
git fetch origin
git checkout -b "$MYBRANCH" 

#### Step 2. Review the changes locally
# Update files
# git add {file}
# git commit -m "Message" {file}

#### Step 3. Merge the branch and fix any conflicts that come up
git fetch origin
#git checkout "origin/master"
git merge --no-ff "$MYBRANCH"

#### Step 4. Push the result of the merge to GitLab
git push --set-upstream origin "$MYBRANCH"

#### Step 5. Request peer review of MR (or merge it yourself)
- Example URL
https://gitlab.consulting.company.com/reports/client-cers/reportn-name-/merge_requests/new?merge_request%5Bsource_branch%5D=$MYBRANCH
```
