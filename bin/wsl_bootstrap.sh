# Set CC as passwordless sudoer
sudo adduser --disabled-password --gecos "" chriscrain && echo "chriscrain ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

# Build wsl.conf
echo -e "[automount]" | sudo tee -a /etc/wsl.conf
echo -e "enabled = true" | sudo tee -a /etc/wsl.conf
echo -e "[user]" | sudo tee -a /etc/wsl.conf
echo -e "default = chriscrain" | sudo tee -a /etc/wsl.conf

# Install apt updates and zsh
apt update -y && apt-get upgrade -y
apt install -y unattended-upgrades

exit