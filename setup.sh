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

# Install chezmoi in /usr/bin
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

# Install dotfiles
chezmoi init --apply https://github.com/ShawnHeyli/dotfiles.git --branch coder
