#!/bin/bash

cd ~

# Locate the Brewfile
BREWFILE="~/.config/brew/Brewfile"
ZSH_CUSTOM="~/.config/ohmyzsh/.zsh_custom"

if [ -z "$BREWFILE" ]; then
  echo "Brewfile not found in the system."
  exit 1
fi

# Install packages from the Brewfile
brew bundle --file="$BREWFILE"
echo "Homebrew and packages from Brewfile installed successfully."


if [ ! -d ~/.vim ]; then
    mkdir ~/.vim
    chmod 777 ~/.vim
fi

# Add .vim undodir for undotree
if [ ! -d ~/.vim/undodir ]; then
    mkdir ~/.vim/undodir/
    chmod 777 ~/.vim/undodir/
fi

# Add debugpy to system python
if ! command -v python3 &> /dev/null
then
    echo "python3 could not be found"
    exit 1
else
    pipx install debugpy
fi

# Add poetry and poetry configs to the system
if ! command -v poetry &> /dev/null; then
    pipx install poetry
fi

if [ ! -d "$ZSH_CUSTOM/plugins/poetry" ]; then
    mkdir -p "$ZSH_CUSTOM/plugins/poetry"
fi

if [ ! -f "$ZSH_CUSTOM/plugins/poetry/_poetry" ]; then
    poetry completions zsh > "$ZSH_CUSTOM/plugins/poetry/_poetry"
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh. This will require elevation."
    chsh -s $(which zsh)
fi

# Install fzf
./$XDG_CONFIG_HOME/fzf/install --xdg --key-bindings --completion --no-update-rc

# Install coder
if ! command -v coder &> /dev/null; then
    echo "Installing coder..."
    curl -L https://coder.com/install.sh | sh
else
    echo "Coder is already installed."
fi

exec zsh
