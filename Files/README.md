# cloudxabide/devops

## Project Overview

This repository contains a collection of shell scripts, configuration files, and utilities that automate common system‑level tasks across multiple operating systems.  The goal is to provide a single, easily‑maintained set of scripts that can be sourced on any machine – Linux, macOS, or Windows (WSL).

## Quick‑Start

1. **Clone the repo**
   ```bash
   git clone https://github.com/cloudxabide/devops.git
   cd devops
   ```
2. **Install prerequisites** (example for Debian‑based systems):
   ```bash
   sudo apt-get update
   sudo apt-get install -y shellcheck git
   ```
3. **Run the pre‑commit hook** to lint scripts before committing:
   ```bash
   chmod +x .git/hooks/pre-commit
   ```
4. **Source the configuration** you need:
   ```bash
   source .bashrc
   source .zshrc
   ```

## Directory Layout

- `./` – root scripts and utilities (e.g. `choose_aws_profile.sh`).
- `./.bashrc.d_*` – OS‑specific snippets that are automatically sourced by `.bashrc`.
- `./.vimrc` / `./.vimrc.plug` – Vim configuration.
- `./.gitignore` – Repository ignore patterns.
- `./.claude/settings.local.json` – Claude Code harness settings.
- `./.git/hooks/pre-commit` – Linting hook for shellcheck.

## Contribution Guide

1. Fork the repository.
2. Create a feature/bug‑fix branch.
3. Run `./.git/hooks/pre-commit` (or `git commit -n`) to ensure scripts lint.
4. Submit a pull request with a clear description.
5. The CI will run `shellcheck` and `bash -n` on all shell scripts.

Feel free to open issues for feature requests or bugs. Happy hacking!


## Status
Work in Progress.

I need to make this content universally applicable to any of the systems I might have.  

I will create content that is:

* common
* OS-specific


