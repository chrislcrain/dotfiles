#!/bin/bash

# Set some environment variables
export PATH="/usr/bin:$PATH"
export ZSH_CUSTOM="$HOME/.config/ohmyzsh/.zsh_custom"

cd ~

# Update package list
sudo apt update

# Essential build tools (for some language tools)
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git zsh

# Install pyenv
if [ ! -d ~/.pyenv ]; then
    curl https://pyenv.run | bash
fi

# Install azure-cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# Core utilities
sudo apt install -y xz-utils azure-cli direnv gh git pipx ripgrep wget luarocks

# chezmoi (official script, as apt repo may not be up-to-date)
sh -c "$(curl -fsLS get.chezmoi.io)"

# Powershell
sudo apt install -y wget apt-transport-https software-properties-common
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y powershell

# HashiCorp tools (terraform and packer)
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y terraform packer

# 1Password CLI
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo tee /etc/apt/trusted.gpg.d/1password.asc
echo 'deb [arch=amd64] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
sudo apt update
sudo apt install -y 1password-cli

# Node.js (if you want latest, use NodeSource)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Clean up
rm -f packages-microsoft-prod.deb


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
pipx install debugpy

# Add poetry and poetry configs to the system
if ! command -v poetry &> /dev/null; then
    pipx ensurepath
    pipx install poetry
fi

if [ ! -d "$ZSH_CUSTOM/plugins/poetry" ]; then
    mkdir -p "$ZSH_CUSTOM/plugins/poetry"
fi

if [ ! -f "$ZSH_CUSTOM/plugins/poetry/_poetry" ]; then
    poetry completions zsh > "$ZSH_CUSTOM/plugins/poetry/_poetry"
fi

/opt/nvim-linux-x86_64/bin/nvim --headless "+Lazy! sync" +qa

sudo chsh "$(id -un)" --shell "/usr/bin/zsh"

exec zsh
