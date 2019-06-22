# GIT Cheatsheet

## .gitignore tweaks
```
 # Tweak GIT
git config --global core.excludesfile ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global
echo ".gitignore" >> ~/.gitignore_global
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

> **_NOTE:_**  Here is a blockquote

    **_NOTE:_**  Here is a "double tab"
