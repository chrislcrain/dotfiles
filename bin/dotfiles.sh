#!/bin/bash
cd ~

apt-get install zsh -y

ZSH=$HOME/.config/ohmyzsh/.oh-my-zsh ZSH_CUSTOM=$HOME/.config/ohmyzsh/.zsh_custom sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Uncomment this if setting up for WSL - 1Password integration
git config --global core.sshCommand ssh.exe
git clone --bare git@github.com:chrislcrain/dotfiles.git $HOME/.dotfiles

git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME fetch --all
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME reset --hard
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME submodule update --force --recursive --init --remote

git config --global user.email "22624146+chrislcrain@users.noreply.github.com"
git config --global user.name "Your Name"

# Set zsh as default shell
sudo chsh -s $(which zsh)

exec zsh
