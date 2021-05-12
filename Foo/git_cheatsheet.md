# GIT Cheatsheet

## Clone ALL of my public repos (private requires an API key)
It is expected that you already have your SSH key configured for each GIT repo(user) you're about to clone.  
```
URL=api.github.com
USERS="cloudxabide ridexabide jradtke-rh"
cd
for USER in $USERS
do
  mkdir -p ~/Repositories/$USER; cd $_
  for REPO in $(curl -s https://$URL/users/$USER/repos | grep "ssh_url" | awk '{ print $2 }' | sed 's/,//g' | sed 's/"//g')
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
#### Nuclear Option(s)
```
git checkout -- .
```

## Moving from master to main (rename)
I have ZERO interest discussing this with anyone when it comes up at work.  It's fairly trivial to deploy (for most) and I don't see why lengthy
discussions about freedom and slippery-slopes, etc.. even begin.  That said, I am NOT even very good at using git, and this was very simple to enact...

Browse to your repo and click on "master" above the filesystem view, then click on "View all branches"
Click the pencil on the right-hand side of that view and replace "master" with "main"
Click on "< > Code" and it will display a handy set of commands to run locally to update your copy
 

### Just commands
```
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a
```

### Actual Output
```
cyberpunk:aws-terraform jradtke$ git branch -m master main
cyberpunk:aws-terraform jradtke$ git fetch origin
From github.com:cloudxabide/aws-terraform
 * [new branch]      main       -> origin/main
cyberpunk:aws-terraform jradtke$ git branch -u origin/main main
Branch 'main' set up to track remote branch 'main' from 'origin'.
cyberpunk:aws-terraform jradtke$ git remote set-head origin -a
origin/HEAD set to main
cyberpunk:aws-terraform jradtke$ git branch
* main
```

### Theory/suspicions
I *think* that for most cases, you can simply replace "master" with "HEAD" if you are using some code to pull something down.
I had documented how to install Homebrew for my team and a code scan/audit identified the URL which needed to be reviewed.  I then checked out https://brew.sh and noticed they had already updated THEIR installation docs to remove the "master" reference - which then made me curious:  can I just replace "master" with "HEAD" and be done with it.  A:  Seems like it?

For example:  Brew used to utilize 
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```
Which has been replaced with:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

### Git rec'd process
-- this still needs tweaking
```
MYBRANCH="`whoami`-`date +%F-%H%M%S`"

#### Step 1. Fetch and check out the branch for this merge request
git checkout main 
git fetch origin
git checkout -b "$MYBRANCH" 

#### Step 2 Update and review the changes locally
# Update {file}

#### Step 2a. 
# git add {file}
# git commit -m "Message" {file}

#### Step 3. Merge the branch and fix any conflicts that come up
git fetch origin
git merge --no-ff "$MYBRANCH"

#### Step 4. Push the result of the merge to GitLab
git push --set-upstream origin "$MYBRANCH"

#### Step 5. Request peer review of MR (or merge it yourself)
- Example URL
https://gitlab.consulting.company.com/reports/client-cers/reportn-name-/merge_requests/new?merge_request%5Bsource_branch%5D=$MYBRANCH
```

## Compare a branch to master (or another branch, I suppose)
If you manage to get yourself in a spot where you don't know what changes were staged
```
git checkout <branch>
git diff --name-only main
```

## Duplicating a repo
If you have a reason to duplicate a repo (say you have an internal/on-prem repo that you'd like to push to github...)

```
$ git clone --bare https://github.com/exampleuser/old-repository.git
$ cd old-repository.git
$ git push --mirror https://github.com/exampleuser/new-repository.git
$ cd ..
$ rm -rf old-repository.git
```

## References
I decided to start collecting some of the resources I have found helpful  

[[Linux.conf.au 2013] - Git For Ages 4 And Up](https://www.youtube.com/watch?v=1ffBJ4sVUb4)
