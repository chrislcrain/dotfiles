#!/bin/bash
cd ~

# Uncomment this if setting up for WSL - 1Password integration
# git config --global core.sshCommand ssh.exe

git config --global user.email "22624146+chrislcrain@users.noreply.github.com"
git config --global user.name "Your Name"

git clone --bare git@github.com:chrislcrain/dotfiles.git $HOME/.dotfiles

git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch --all
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME reset --hard
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME submodule update --force --recursive --init --remote

sudo apt update

ZSH=$HOME/.config/ohmyzsh/.oh-my-zsh ZSH_CUSTOM=$HOME/.config/ohmyzsh/.zsh_custom sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp ~/.zshrc.pre-oh-my-zsh ~/.zshrc

# Set zsh as default shell
sudo chsh -s $(which zsh)

# Get lua
sudo apt-get install build-essential libreadline-dev unzip -y
curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
tar -zxf lua-5.3.5.tar.gz
cd lua-5.3.5
make linux test
sudo make install

sudo apt-get install npm -y
sudo apt-get install luarocks -y
sudo apt-get install python3-venv -y

# Install PowerShell
# sudo apt-get install -y wget apt-transport-https software-properties-common
# source /etc/os-release
# curl -R -O https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
# sudo dpkg -i packages-microsoft-prod.deb
# rm packages-microsoft-prod.deb
# sudo apt-get update
# sudo apt-get install -y powershell

sudo apt-get update

# python fixes
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Install neovim
sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm -f ~/.nvim-linux64.tar.gz

# Need to chmod 777 .vim directory
mkdir ~/.vim
mkdir ~/.vim/undodir/
sudo chmod 777 ~/.vim
sudo chmod 777 ~/.vim/undodir/
sudo chsh -s $(which zsh) $(whoami)

exec zsh
