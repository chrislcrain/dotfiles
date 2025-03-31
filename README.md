# dotfiles

# Dotfiles

## Requirements

- `git`
- `homebrew`
- `chezmoi`
- `zsh`
<!-- - `curl` or `wget` (for [Zinit](https://github.com/zdharma-continuum/zinit)) -->

## Initial Setup

Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install chezmoi

```sh
brew install chezmoi
```

Clone repo files to chezmoi directory and sync files

```sh
chezmoi cd
git init
git remote add origin -t chezmoi-migration https://github.com/chrislcrain/dotfiles.git
git pull
chezmoi init
chezmoi apply
source ~/.config/shell/environment
```

Run bootstrap script

```sh
sh ~/bootstrap.sh
```
