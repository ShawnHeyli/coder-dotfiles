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
chezmoi init --apply https://github.com/ShawnHeyli/dotfiles.git --branch proxmox

### VSCODE ###

extensions = (
	catppuccin.catppuccin-vsc
	github.copilot
	eamodio.gitlens
	pkief.material-icon-theme
	pkief.material-product-icons
	esbenp.prettier-vscode
)

for extension in "${extensions[@]}"
do
  code --install-extension "$extension"
done

declare -A vscode_settings=(
    ["workbench.colorTheme"]="Catppuccin Macchiato"
    ["editor.tabSize"]=2
    ["files.autoSave"]="onFocusChange"
    ["editor.formatOnSave"]= true,
    ["editor.fontSize"]=16
    ["editor.fontWeight"]= "500",
    ["workbench.productIconTheme"]= "material-product-icons"
    ["workbench.iconTheme"]= "material-icon-theme",
    ["editor.fontFamily"]= "'ComicCodeLigatures Nerd Font Mono','BlexMono Nerd Font', 'IBM Plex Mono', 'Fira Code', 'Source Code Pro', Consolas",
)

for key in "${!vscode_settings[@]}"; do
    value="${vscode_settings[$key]}"
    if grep -q "\"$key\": *\".*\"" "$settings_file"; then
        sed -i "s/\(\"$key\": *\".*\"\)/\"$key\": \"$value\"/g" "$settings_file"
    else
        echo "\"$key\": \"$value\"," >> "$settings_file"
    fi
done
