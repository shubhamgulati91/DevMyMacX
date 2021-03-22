#!/bin/sh

# Input variables
EDITOR=$1

# Script variables
DEFAULT_DOTFILES_REPO='https://github.com/shubhamgulati91/dotfiles'

setup_vscode () {
    echo "Setting up VSCode..."
    if ! test $(which code); then
        echo "Maybe try installing VSCode first."
        exit 1
    fi

    echo "Installing VSCode extensions... \c"
    sh -c "$(curl -fsSL $DEFAULT_DOTFILES_REPO/raw/main/macOS/vscode/install-extensions.sh)" "" "code" &>/dev/null
    echo "Done"
    echo "Installing VSCode user settings... \c"
    curl -Ls $DEFAULT_DOTFILES_REPO/raw/main/macOS/vscode/settings.json > ~/Library/Application\ Support/Code/User/settings.json
    echo "Done"
}

setup_vscode_insiders () {
    echo "Setting up VSCode Insiders..."
    if ! test $(which code-insiders); then
        echo "Maybe try installing VSCode Insiders first."
        exit 1
    fi

    echo "Installing VSCode extensions... \c"
    sh -c "$(curl -fsSL $DEFAULT_DOTFILES_REPO/raw/main/macOS/vscode/install-extensions.sh)" "" "code-insiders" &>/dev/null
    echo "Done"
    echo "Installing VSCode user settings... \c"
    curl -Ls $DEFAULT_DOTFILES_REPO/raw/main/macOS/vscode/settings.json > ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
    echo "Done"
}

while [[ "$#" -gt 0 ]]; do
    case $EDITOR in
        -code|--visual-studio-code) setup_vscode; shift ;;
        -code-insiders|--visual-studio-code-insiders) setup_vscode_insiders; shift ;;
        *) echo "$0: Unknown parameter passed: $EDITOR"; exit 1 ;;
    esac
    shift
done
