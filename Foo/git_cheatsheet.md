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

## .gitignore tweaks
```
 # Tweak GIT
echo ".DS_Store" >> ~/.gitignore_global
echo ".gitignore" >> ~/.gitignore_global
echo ".gitconfig" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
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
