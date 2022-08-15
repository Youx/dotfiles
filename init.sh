#!/bin/sh

# {{{ Helpers

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

SCRIPT_DIR=$(dirname $0)
DATA_CONFIG="$SCRIPT_DIR/config"
HOME_CONFIG="$HOME/.config"

# }}}
# {{{ Check installed software

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

# }}}
# {{{ Copy files

# Create .config dir
if [ ! -d "$HOME_CONFIG" ]; then
    echo "Creating directory $HOME_CONFIG"
    mkdir "$HOME_CONFIG"
fi

echo "Copying config files"
function copy_config()
{
    in_conf="$DATA_CONFIG/$1"
    out_conf="$HOME_CONFIG/$1"
    if [ -e "$out_conf" ]; then
        echo "Overwrite $out_conf?"
        gum confirm && rm -fr "$out_conf" && cp -r "$in_conf" "$HOME_CONFIG" && print_ok "copied $in_conf to $out_conf"
    else
        cp -r "$in_conf" "$HOME_CONFIG" && print_ok "copied $in_conf to $out_conf"
    fi
}

for i in "$(ls $DATA_CONFIG)"; do
    copy_config "$i"
done

# }}}
# {{{ Setup software
# {{{ Initialize neovim plugins
gum spin --title "Setting up Neovim" -- nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
# }}}
# }}}
