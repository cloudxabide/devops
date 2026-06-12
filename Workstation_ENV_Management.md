# Workstation ENV Management

Notes regarding how I would like to manage my "local" environment on my workstations

I would like to create an appraoch that limits the possibility of me oversharing sensitive information, while maintainig the functionality I need.  More specifically: I like having useful artifacts in ~/.bashrc.d/ based on the tool or use (a file for K8s, or AI, or... "OS variant") - but... I don't want to have any sensitive data in those files (like API key, or AWS creds, etc...)

NOTES:
If I *have* to use long-lived credentials for some reason, I'd rather not just dump them in ~/.aws/credentials - this is partially "security through obscurity" (which is easy enough to unravel the mystery), but

```
~/.bashrc.d/AI
if [ -f ~/.config/AI/creds ] then . ~/.config/AI/creds; fi
```

More generically
```
$HOME/.bashrc.d/$ENV_RC
if [ -f ~/.config/$ENV_RC/creds ] then . ~/.config/$ENV_RC/creds; fi
```

Now - do I add that code to each RC file?  Or... should I add logic in $HOME/.bashrc to execute based on what it finds in $HOME/.bashrc.d/ (trending towards latter)

## TL;DR: implement this bashrc approach
```
# Safely iterate over the directory using globbing instead of $(find ...)
for RC in "$HOME"/.bashrc.d/*
do
  # Guard against an empty directory (where the literal string '* ' is returned)
  [[ -e "$RC" ]] || continue 

  # Properly quote variables to prevent issues with spaces in file paths
  CREDS_FILE="${HOME}/.config/$(basename "$RC")/creds"
  echo "sourcing $CREDS_FILE"
  
  # Use [[ ... ]] for file testing instead of arithmetic (( ... ))
  [[ -f "$CREDS_FILE" ]] && source "$CREDS_FILE"
done
```



