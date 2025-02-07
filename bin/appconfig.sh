#!/bin/zsh

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
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz

# Need to chmod 777 .vim directory
mkdir ~/.vim
mkdir ~/.vim/undodir/
sudo chmod 777 ~/.vim
sudo chmod 777 ~/.vim/undodir/
