#!/bin/bash

### CHEZMOI ###

# Install required packages using package manager
if command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y curl sudo git
elif command -v dnf &> /dev/null; then
    sudo dnf update && sudo dnf install -y curl sudo git
elif command -v pacman &> /dev/null; then
    sudo pacman -Syu --noconfirm && sudo pacman -S --noconfirm curl sudo git
elif command -v apk &> /dev/null; then
    sudo apk update && sudo apk add curl sudo git
elif command -v yum &> /dev/null; then
    sudo yum update && sudo yum install -y curl sudo git
else
    echo "Error: no supported package manager found"
    exit 1
fi

# Install chezmoi in ~/.bin
mkdir ~/.bin
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.bin
echo 'export PATH=$PATH://home/coder'  >> ~/.bash_profile

# Add ~/.bin directory to PATH
if [ -f "$HOME/.bashrc" ]; then
    echo 'export PATH="$HOME/.bin:$PATH"' >> $HOME/.bashrc
    source $HOME/.bashrc
fi

if [ -f "$HOME/.zshrc" ]; then
    echo 'export PATH="$HOME/.bin:$PATH"' >> $HOME/.zshrc
    source $HOME/.zshrc
fi

if [ -f "$HOME/.config/fish/config.fish" ]; then
    echo 'set PATH $HOME/.bin $PATH' >> $HOME/.config/fish/config.fish
    source $HOME/.config/fish/config.fish
fi

if [ -f "$HOME/.profile" ]; then
    echo 'export PATH="$HOME/.bin:$PATH"' >> $HOME/.profile
    source $HOME/.profile
fi


# Install dotfiles
chezmoi init --apply https://github.com/ShawnHeyli/dotfiles.git --branch coder
