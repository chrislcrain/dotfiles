#!/bin/bash

# Set environment variables for user-local installations
export PATH="$HOME/.local/bin:$PATH"
export ZSH_CUSTOM="$XDG_CONFIG_HOME/ohmyzsh/.zsh_custom"

cd $HOME

# Ensure local bin exists
mkdir -p "$HOME/.local/bin"

# Install essential build tools for compiling language tools (still requires apt)
sudo apt update
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git zsh

# Install pyenv (installs to $HOME/pyenv)
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Install Azure CLI (pipx user install)
pipx install azure-cli

# Install core utilities
sudo apt install -y direnv gh git pipx ripgrep wget luarocks

# Install chezmoi (user-local)
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"

# Install PowerShell (user-local, official tarball)
POWERSHELL_VERSION="7.4.1"
curl -LO "https://github.com/PowerShell/PowerShell/releases/download/v$POWERSHELL_VERSION/powershell-$POWERSHELL_VERSION-linux-x64.tar.gz"
mkdir -p "$HOME/.local/pwsh"
tar -xzf "powershell-$POWERSHELL_VERSION-linux-x64.tar.gz" -C "$HOME/.local/pwsh"
ln -sf "$HOME/.local/pwsh/pwsh" "$HOME/.local/bin/pwsh"
rm "powershell-$POWERSHELL_VERSION-linux-x64.tar.gz"

# Install HashiCorp tools (Terraform, Packer) user-local
for tool in terraform packer; do
  LATEST=$(curl -s "https://checkpoint-api.hashicorp.com/v1/check/$tool" | grep -Po '"current_version":.*?[^\\]",' | awk -F'"' '{print $4}')
  curl -Lo "$HOME/.local/bin/$tool.zip" "https://releases.hashicorp.com/$tool/${LATEST}/${tool}_${LATEST}_linux_amd64.zip"
  unzip -o "$HOME/.local/bin/$tool.zip" -d "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/$tool"
  rm "$HOME/.local/bin/$tool.zip"
done

# Install Node.js (user-local, via n or nvm)
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o "$HOME/.local/bin/n"
chmod +x "$HOME/.local/bin/n"
export N_PREFIX="$HOME/.local"
"$HOME/.local/bin/n" latest

# Clean up
rm -f packages-microsoft-prod.deb

# Set up .vim and undodir
mkdir -p $HOME/vim/undodir
chmod 777 $HOME/vim $HOME/vim/undodir

# Install debugpy (pipx user-local)
pipx install debugpy

# Install poetry (pipx user-local)
if ! command -v poetry &> /dev/null; then
    pipx install poetry
fi

# Poetry zsh completions
if [ ! -d "$ZSH_CUSTOM/plugins/poetry" ]; then
    mkdir -p "$ZSH_CUSTOM/plugins/poetry"
fi
if [ ! -f "$ZSH_CUSTOM/plugins/poetry/_poetry" ]; then
    poetry completions zsh > "$ZSH_CUSTOM/plugins/poetry/_poetry"
fi

# Install and autoconfig fzf
if [ -d $XDG_CONFIG_HOME/fzf ]; then
  $XDG_CONFIG_HOME/fzf/install --no-update-rc --xdg --completion --key-bindings
else
    echo "fzf is missing!"
fi

# Install treesitter cli
gunzip -d "$HOME/.local/tree-sitter-cli/tree-sitter-linux-x64.gz"
chmod +x "$HOME/.local/tree-sitter-cli/tree-sitter-linux-x64"
if [ ! -e "$HOME/.local/bin/tree-sitter" ]; then
    ln -s "$HOME/.local/tree-sitter-cli/tree-sitter-linux-x64" "$HOME/.local/bin/tree-sitter"
fi

# Run Neovim first time configs and add to PATH
$HOME/.local/nvim/bin/nvim --headless "+Lazy! sync" +qa
if [ ! -e "$HOME/.local/bin/nvim" ]; then
    ln -s "$HOME/.local/nvim/bin/nvim" "$HOME/.local/bin/nvim"
fi

exec zsh
