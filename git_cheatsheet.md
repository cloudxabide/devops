# GIT Cheatsheet


## .gitignore
I had found myself in a place where no matter how I updated my .gitignore, certain files were still being analyzed and then reported against.  After some research I learned it was because I had told git to track them, prior to updating my ./.gitignore and therefore git still "knew" about the files.  
### Cleanup 
```
git rm -r --cached .
git add .
git commit -m "fixed untracked files"
```

