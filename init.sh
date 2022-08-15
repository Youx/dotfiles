#!/bin/sh

COLOR_RED='\033[00;31m'
COLOR_GREEN='\033[00;32m'
COLOR_RESET='\033[0m'

function print_ok()
{
    echo "${COLOR_GREEN}✓${COLOR_RESET} $1"
}

function print_ko()
{
    echo "${COLOR_RED}✗${COLOR_RESET} $1"
}

# Install

missing_command=0
function check_command()
{
    if [ ! -x "$(command -v $1)" ]; then
        print_ko "$1 not installed ($2)"
        missing_command=1
    else
        print_ok "$1 is installed"
    fi
}

echo "Check installed software"
check_command "gum"     "https://github.com/charmbracelet/gum"
check_command "nvim"    "https://neovim.io"
check_command "kitty"   "https://sw.kovidgoyal.net/kitty"
check_command "zsh"     ""

if [ $missing_command -eq 1 ]; then
    exit 1;
fi

echo "Copying config files"
# Create .config dir
if [ ! -d "$HOME/.config" ]; then
    echo "Creating directory ~/.config"
    mkdir "$HOME/.config"
fi

function copy_config()
{
    if [ -e "$HOME/.config/$1" ]; then
        echo "Overwrite config $1?"
        gum confirm && rm -fr "$HOME/.config/$1" && cp -r ".config/$1" "$HOME/.config" && print_ok "copied .config/$1"
    else
        cp -r ".config/$1" "$HOME/.config/" && print_ok "copied .config/$1"
    fi
}

for i in "$(ls .config/)"; do
    copy_config "$i"
done

# Initialize neovim plugins
gum spin --title "Setting up Neovim" -- nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
