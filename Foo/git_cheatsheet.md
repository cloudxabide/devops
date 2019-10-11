# GIT Cheatsheet

## Clone ALL of my public repos (private requires an API key)
It is expected that you already have your SSH key configured for GIT
```
for USER in cloudxabide ridexabide jradtke-rh
do
  mkdir -p ~/Repositories/$USER; cd $_
  for REPO in $(curl -s https://api.github.com/users/$USER/repos | grep "ssh_url" | awk '{ print $2 }' | sed 's/,//g' | sed 's/"//g')
  do
    git clone $REPO
  done
done
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

\> **_NOTE:_**  Here is a blockquote  
> **_NOTE:_**  Here is a blockquote  


\<space x 4\>\**\_NOTE:\_**  Here is a "double tab" with Emphasis '_' and Bold '**'  

    **_NOTE:_**  Here is a "double tab"

