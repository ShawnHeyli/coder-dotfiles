#!/bin/bash

### PACKAGES ###

sudo apt-get update -y

packages = (
    neovim
    git
    ripgrep
    exa
    bat
    unzip
)
for package in "${packages[@]}"
do
  sudo apt install "$extension" -y
done

### VSCODE ###

extensions = (
	catppuccin.catppuccin-vsc
	vscjava.vscode-java-pack
	github.copilot
	eamodio.gitlens
	pkief.material-icon-theme
	pkief.material-product-icons
	esbenp.prettier-vscode
	sonarsource.sonarlint-vscode
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

### ZSH ###
# Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
cp .zshrc ~/.zshrc

### FONTS
cp -r fonts/* /usr/local/share/fonts
