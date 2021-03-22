#!/bin/sh

source utils/functions.sh

# Input variables
SETUP_MODE=$1
SETUP_PACKAGE=$2

# Homebrew variables
DEFAULT_BREWFILES_CHECHOUT_LOCATION=$(dirname "$0")/.Brewfiles
DEFAULT_BREWFILE_APP_STORE='Brewfile-1-App-Store-Bundle'
DEFAULT_BREWFILE_ESSENTIALS='Brewfile-2-Essential-Bundle'
DEFAULT_BREWFILE_DEVELOPER='Brewfile-3-Developer-Bundle'
DEFAULT_BREWFILE_MSOFFICE='Brewfile-4-MS-Office-Bundle'
DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION=$HOME/.Backup

# Script variables
DEFAULT_PROMPT_TIMEOUT=0
DEFAULT_EDIT_BREWFILES='n'
DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'
DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='n'
DEFAULT_INSTALL_BUNDLE_MSOFFICE='n'

# Ask for the administrator password upfront.
echo "Requesting admin access... \c"
sudo -v
echo "${GREEN}Running as admin${NC}"

# Keep sudo until script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

interactive_setup() {
  PROMPT_TIMEOUT=$1
  [ -z "${PROMPT_TIMEOUT}" ] && PROMPT_TIMEOUT=$DEFAULT_PROMPT_TIMEOUT;

  echo
  echo "Dotfiles source repository [default: ${BLUE}$DEFAULT_DOTFILES_SRC${NC}]"; read -t $PROMPT_TIMEOUT -n 200 -sp "--> " DOTFILES_SRC ; [ -z "${DOTFILES_SRC}" ] && DOTFILES_SRC=$DEFAULT_DOTFILES_SRC; echo ${GREEN}$DOTFILES_SRC${NC}; echo
  echo "Edit Brewfiles before installing? [default: ${BLUE}$DEFAULT_EDIT_BREWFILES${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " EDIT_BREWFILES ; [ -z "${EDIT_BREWFILES}" ] && EDIT_BREWFILES=$DEFAULT_EDIT_BREWFILES; echo ${GREEN}$EDIT_BREWFILES${NC}; echo
  echo "Install Essentials Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_ESSENTIALS${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_ESSENTIALS ; [ -z "${INSTALL_BUNDLE_ESSENTIALS}" ] && INSTALL_BUNDLE_ESSENTIALS=$DEFAULT_INSTALL_BUNDLE_ESSENTIALS; echo ${GREEN}$INSTALL_BUNDLE_ESSENTIALS${NC}; echo
  echo "Install Development Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_DEVELOPMENT ; [ -z "${INSTALL_BUNDLE_DEVELOPMENT}" ] && INSTALL_BUNDLE_DEVELOPMENT=$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT; echo ${GREEN}$INSTALL_BUNDLE_DEVELOPMENT${NC}; echo
  echo "Install MS Office Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_MSOFFICE${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_MSOFFICE ; [ -z "${INSTALL_BUNDLE_MSOFFICE}" ] && INSTALL_BUNDLE_MSOFFICE=$DEFAULT_INSTALL_BUNDLE_MSOFFICE; echo ${GREEN}$INSTALL_BUNDLE_MSOFFICE${NC}; echo

  echo
  checkout_private_data_repository
}

set_default_values() {
  AUTOMATIC_SETUP_PACKAGE=$1

  echo
  echo "${GREEN}Deploying \c${NC}"

  case $AUTOMATIC_SETUP_PACKAGE in
    -l|--lean) echo "${GREEN}lean update package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y' ;;
    -e|--express) echo "${GREEN}express update package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'; DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='y' ;;
    -f|--full|*) echo "${GREEN}full update package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'; DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='y'; DEFAULT_INSTALL_BUNDLE_MSOFFICE='y' ;;
  esac

  set_user_properties

  DOTFILES_SRC=$DEFAULT_DOTFILES_SRC
  EDIT_BREWFILES=$DEFAULT_EDIT_BREWFILES
  INSTALL_BUNDLE_ESSENTIALS=$DEFAULT_INSTALL_BUNDLE_ESSENTIALS
  INSTALL_BUNDLE_DEVELOPMENT=$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT
  INSTALL_BUNDLE_MSOFFICE=$DEFAULT_INSTALL_BUNDLE_MSOFFICE

  COMPUTER_NAME=$DEFAULT_COMPUTER_NAME
  HOSTNAME=$DEFAULT_HOSTNAME
  LOCAL_HOSTNAME=$DEFAULT_LOCAL_HOSTNAME
  GIT_USER_NAME=$DEFAULT_GIT_USER_NAME
  GIT_USER_EMAIL=$DEFAULT_GIT_USER_EMAIL
}

case $SETUP_MODE in
  -a|--automatic|-d|--debug) set_default_values $SETUP_PACKAGE; interactive_setup 1 ;;
  -m|--manual|*) set_default_values $SETUP_PACKAGE; interactive_setup 60 ;;
esac

echo
echo "Creating local snapshot using Time Machine before making changes... \c"
sudo tmutil localsnapshot &>/dev/null
echo "Done"

echo
echo "Updating Homebrew to latest version... \c"
brew update &>/dev/null
echo "Done"

echo
echo "Upgrading already-installed Homebrew formulae..."
brew upgrade

echo
echo "Cleaning up outdated versions from homebrew cellar... \c"
brew cleanup &>/dev/null
echo "Done"

echo
BREWFILES_SRC="$DOTFILES_SRC/raw/main/macOS/homebrew"
echo "Fetching brewfiles from ${BLUE}$BREWFILES_SRC${NC} to $DEFAULT_BREWFILES_CHECHOUT_LOCATION ... \c"
rm -rf $DEFAULT_BREWFILES_CHECHOUT_LOCATION &>/dev/null && mkdir $DEFAULT_BREWFILES_CHECHOUT_LOCATION &>/dev/null
echo "Done"

# Install Brewfiles
install_bundle $DEFAULT_BREWFILE_APP_STORE $INSTALL_BUNDLE_ESSENTIALS
install_bundle $DEFAULT_BREWFILE_ESSENTIALS $INSTALL_BUNDLE_ESSENTIALS
install_bundle $DEFAULT_BREWFILE_DEVELOPER $INSTALL_BUNDLE_DEVELOPMENT
install_bundle $DEFAULT_BREWFILE_MSOFFICE $INSTALL_BUNDLE_MSOFFICE

echo
echo "Checking for problems with Homebrew... \c"
brew doctor &>/dev/null
echo "Done"

echo
echo "Updating Oh My Zsh... \c"
if [ -d "$HOME/.oh-my-zsh" ]; then env ZSH=$ZSH sh $ZSH/tools/upgrade.sh &>/dev/null; fi
echo "Done"

echo
echo "Updating Mac App Store Applications..."
sudo softwareupdate -i -a

# echo
# Install user apps from cloud backup
# sh utils/user-apps.sh

# echo
# Update Node & NPM
# sh utils/sdk.sh -nvm-node

echo
# Backing up application and personal config files to cloud
sh utils/mackup.sh --backup

echo
echo "${YELLOW}Thanks for using DevMyMacX!${NC}"
echo "${YELLOW}If you liked it, make sure to go to the GitHub repo (https://github.com/shubhamgulati91/DevMyMacX) and star it!${NC}"
echo "${YELLOW}If you have any issues, just put them there. All suggestions and contributions are appreciated!${NC}"
