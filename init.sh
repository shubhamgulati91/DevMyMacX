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

# Script variables
DEFAULT_PROMPT_TIMEOUT=0
DEFAULT_EDIT_BREWFILES='n'
DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'
DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='n'
DEFAULT_INSTALL_BUNDLE_MSOFFICE='n'
DEFAULT_DELETE_ALL_DOCK_ICONS='n'

# Check if XCode Command line tools are installed
if ! (type xcode-select >&- && xpath=$( xcode-select --print-path ) && test -d "${xpath}" && test -x "${xpath}") ; then
    echo "${RED}Need to install the XCode Command Line Tools (or XCode) first! Starting install...${NC}"
    # Install XCode Command Line Tools
    xcode-select --install &>/dev/null
    exit 1
fi

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
  echo "Computer name [default: ${BLUE}$DEFAULT_COMPUTER_NAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " COMPUTER_NAME ; [ -z "${COMPUTER_NAME}" ] && COMPUTER_NAME=$DEFAULT_COMPUTER_NAME; echo ${GREEN}$COMPUTER_NAME${NC}; echo
  echo "Hostname [default: ${BLUE}$DEFAULT_HOSTNAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " HOSTNAME ; [ -z "${HOSTNAME}" ] && HOSTNAME=$DEFAULT_HOSTNAME; echo ${GREEN}$HOSTNAME${NC}; echo
  echo "Local Hostname [default: ${BLUE}$DEFAULT_LOCAL_HOSTNAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " LOCAL_HOSTNAME ; [ -z "${LOCAL_HOSTNAME}" ] && LOCAL_HOSTNAME=$DEFAULT_LOCAL_HOSTNAME; echo ${GREEN}$LOCAL_HOSTNAME${NC}; echo
  echo "Git user name [default: ${BLUE}$DEFAULT_GIT_USER_NAME${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " GIT_USER_NAME ; [ -z "${GIT_USER_NAME}" ] && GIT_USER_NAME=$DEFAULT_GIT_USER_NAME; echo ${GREEN}$GIT_USER_NAME${NC}; echo
  echo "Git user email [default: ${BLUE}$DEFAULT_GIT_USER_EMAIL${NC}]"; read -t $PROMPT_TIMEOUT -n 50 -sp "--> " GIT_USER_EMAIL ; [ -z "${GIT_USER_EMAIL}" ] && GIT_USER_EMAIL=$DEFAULT_GIT_USER_EMAIL; echo ${GREEN}$GIT_USER_EMAIL${NC}; echo
  echo "Delete all icons on Dock? [default: ${BLUE}$DEFAULT_DELETE_ALL_DOCK_ICONS${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " DELETE_ALL_DOCK_ICONS ; [ -z "${DELETE_ALL_DOCK_ICONS}" ] && DELETE_ALL_DOCK_ICONS=$DEFAULT_DELETE_ALL_DOCK_ICONS; echo ${GREEN}$DELETE_ALL_DOCK_ICONS${NC}; echo
  echo "Dotfiles source repository [default: ${BLUE}$DEFAULT_DOTFILES_SRC${NC}]"; read -t $PROMPT_TIMEOUT -n 200 -sp "--> " DOTFILES_SRC ; [ -z "${DOTFILES_SRC}" ] && DOTFILES_SRC=$DEFAULT_DOTFILES_SRC; echo ${GREEN}$DOTFILES_SRC${NC}; echo
  echo "Edit Brewfiles before installing? [default: ${BLUE}$DEFAULT_EDIT_BREWFILES${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " EDIT_BREWFILES ; [ -z "${EDIT_BREWFILES}" ] && EDIT_BREWFILES=$DEFAULT_EDIT_BREWFILES; echo ${GREEN}$EDIT_BREWFILES${NC}; echo
  echo "Install Essentials Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_ESSENTIALS${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_ESSENTIALS ; [ -z "${INSTALL_BUNDLE_ESSENTIALS}" ] && INSTALL_BUNDLE_ESSENTIALS=$DEFAULT_INSTALL_BUNDLE_ESSENTIALS; echo ${GREEN}$INSTALL_BUNDLE_ESSENTIALS${NC}; echo
  echo "Install Development Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_DEVELOPMENT ; [ -z "${INSTALL_BUNDLE_DEVELOPMENT}" ] && INSTALL_BUNDLE_DEVELOPMENT=$DEFAULT_INSTALL_BUNDLE_DEVELOPMENT; echo ${GREEN}$INSTALL_BUNDLE_DEVELOPMENT${NC}; echo
  echo "Install MS Office Bundle? [default: ${BLUE}$DEFAULT_INSTALL_BUNDLE_MSOFFICE${NC}] [y/N]"; read -t $PROMPT_TIMEOUT -n 1 -sp "--> " INSTALL_BUNDLE_MSOFFICE ; [ -z "${INSTALL_BUNDLE_MSOFFICE}" ] && INSTALL_BUNDLE_MSOFFICE=$DEFAULT_INSTALL_BUNDLE_MSOFFICE; echo ${GREEN}$INSTALL_BUNDLE_MSOFFICE${NC}; echo
  echo "Enter the git url for you private backup reporitory [default: ${BLUE}$DEFAULT_PRIVATE_DATA_BACKUP_REPO${NC}]"; read -t $PROMPT_TIMEOUT -n 400 -sp "--> " PRIVATE_DATA_BACKUP_REPO ; [ -z "${PRIVATE_DATA_BACKUP_REPO}" ] && PRIVATE_DATA_BACKUP_REPO=$DEFAULT_PRIVATE_DATA_BACKUP_REPO; echo ${GREEN}$PRIVATE_DATA_BACKUP_REPO${NC}; echo

  echo
  checkout_private_data_repository
}

set_default_values() {
  AUTOMATIC_SETUP_PACKAGE=$1

  echo
  echo "${GREEN}Deploying \c${NC}"

  case $AUTOMATIC_SETUP_PACKAGE in
    -l|--lean) echo "${GREEN}lean installation package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y' ;;
    -e|--express) echo "${GREEN}express installation package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'; DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='y' ;;
    -f|--full|*) echo "${GREEN}full installation package... ${NC}"; DEFAULT_INSTALL_BUNDLE_ESSENTIALS='y'; DEFAULT_INSTALL_BUNDLE_DEVELOPMENT='y'; DEFAULT_INSTALL_BUNDLE_MSOFFICE='y' ;;
  esac

 set_user_properties

  DELETE_ALL_DOCK_ICONS=$DEFAULT_DELETE_ALL_DOCK_ICONS
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

debug_setup() {
  echo "${GREEN}Running in debug mode... ${NC}"
  DEFAULT_DELETE_ALL_DOCK_ICONS='n'
  DELETE_ALL_DOCK_ICONS='n'
}

case $SETUP_MODE in
  -a|--automatic) set_default_values $SETUP_PACKAGE; interactive_setup 1 ;;
  -d|--debug) set_default_values $SETUP_PACKAGE; debug_setup; interactive_setup 1 ;;
  -m|--manual|*) set_default_values $SETUP_PACKAGE; interactive_setup 60 ;;
esac

echo
echo "Creating local snapshot in time machine before making changes... \c"
sudo tmutil localsnapshot &>/dev/null
echo "Done"

# Set computer name
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${HOSTNAME}"
sudo scutil --set LocalHostName "${LOCAL_HOSTNAME}"
dscacheutil -flushcache

echo
# Change settings for native apps and system
sh utils/os-defaults.sh

# Cleanup default junk on dock
[[ ${DELETE_ALL_DOCK_ICONS} =~ ^[Yy]$ ]] && defaults delete com.apple.dock persistent-apps && defaults delete com.apple.dock persistent-others

echo
echo "Installing Rosetta... \c"
if [[ $(sysctl -n machdep.cpu.brand_string)="*Apple*" && $(launchctl list | grep "com.apple.oahd-root-helper") == "" ]]; then
    sudo softwareupdate --install-rosetta --agree-to-license &>/dev/null
fi
echo "Done"

# Check if Xcode is installed and accept license
# sh utils/workarounds.sh --accept-xcode-license

echo
echo "Installing Homebrew... \c"
if test ! $(which brew); then
  yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &>/dev/null
  [ ! -f $HOME/.zprofile ] && touch $HOME/.zprofile
  if ! grep -Fq "/opt/homebrew/bin/brew" ~/.zprofile; then
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
  fi
  eval $(/opt/homebrew/bin/brew shellenv) &>/dev/null
fi
echo "Done"

echo "Disabling Homebrew Analytics... \c"
brew analytics off &>/dev/null
echo "Done"

# Install Mac App Store CLI (mas)
# sh utils/workarounds.sh --brew-mas

# Tap homebrew/bundle
brew tap homebrew/bundle &>/dev/null

echo
BREWFILES_SRC="$DOTFILES_SRC/raw/main/macOS/homebrew"
echo "Fetching Brewfiles from ${BLUE}$BREWFILES_SRC${NC} to $DEFAULT_BREWFILES_CHECHOUT_LOCATION ... \c"
rm -rf $DEFAULT_BREWFILES_CHECHOUT_LOCATION &>/dev/null && mkdir $DEFAULT_BREWFILES_CHECHOUT_LOCATION &>/dev/null
echo "Done"

echo
echo "Installing Mac App Store CLI Support... \c"
brew install mas &>/dev/null
# mas signin $GIT_USER_EMAIL
echo "Done"

# Install Brewfiles
install_bundle $DEFAULT_BREWFILE_APP_STORE $INSTALL_BUNDLE_ESSENTIALS
install_bundle $DEFAULT_BREWFILE_ESSENTIALS $INSTALL_BUNDLE_ESSENTIALS
install_bundle $DEFAULT_BREWFILE_DEVELOPER $INSTALL_BUNDLE_DEVELOPMENT
install_bundle $DEFAULT_BREWFILE_MSOFFICE $INSTALL_BUNDLE_MSOFFICE

echo
echo "Installing Oh My Zsh... \c"
if test $(which zsh) && [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>/dev/null
  echo "Done"

  echo "Activating zsh plugins..."

  echo "Activating autojump... \c"
  echo '[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && source /opt/homebrew/etc/profile.d/autojump.sh' >> ~/.zshrc
  echo "Done"

  echo "Activating zsh-syntax-highligting... \c"
  echo '[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc
  echo 'export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters' >> ~/.zshenv
  echo "Done"

  echo "Activating zsh-completions... \c"
  echo 'FPATH=/opt/homebrew/share/zsh/site-functions:$FPATH' >> ~/.zprofile
  rm -f ~/.zcompdump &>/dev/null; compinit &>/dev/null
  chmod -R go-w "/opt/homebrew/share" &>/dev/null
  echo "Done"

  echo "Activating zsh-autosuggestions... \c"
  echo '[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
  echo "Done"

  echo "Activating zsh-navigation-tools... \c"
  echo '[ -f /opt/homebrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh ] && source /opt/homebrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh' >> ~/.zshrc
  echo "Done"

  echo "Activating oh-my-zsh plugins... \c"
  sed -io 's/^plugins=.*/plugins=(git brew common-aliases copydir copyfile encode64 node osx xcode pod docker git-extras git-prompt)/' ~/.zshrc
  echo "Done"
fi

echo "Installing zsh theme: powerlevel10k... \c"
if test $(which zsh) && ! grep -q 'source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme' ~/.zshrc; then
  brew install romkatv/powerlevel10k/powerlevel10k &>/dev/null
  # sed -io 's/[{^#| }]*ZSH_THEME="[^"]*/ZSH_THEME="powerlevel10k\/powerlevel10k/g' ~/.zshrc # causes error; powerlevel10k recommends commenting out the theme;
  sed -io '/^ZSH_THEME/ s/^\#*/\# /' ~/.zshrc
  echo '[ -f /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme ] && source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
  curl -Ls $DOTFILES_SRC/raw/main/macOS/zsh/p10k.zsh > ~/.p10k.zsh
  {
    echo ''
    echo '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.'
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'
  } >> ~/.zshrc
fi
echo "Done"

echo
sh utils/editor.sh -code

echo
# Create Developer directory tree and set custom folder icons
echo "Creating Developer directory tree... \c"
mkdir -p $HOME/{Developer/{Code,Projects/{Archive,Current,IntelliJIDEA,DataGrip,WebStorm,VSCode,Postman/files,iMovie},Source/{Bitbucket,GitHub,GitLab}},Sync} &>/dev/null
echo "Done"

echo
# Set custom folder icons
sh utils/folderify.sh

echo
echo "Create user's bin directory and add to path... \c"
[ ! -d $HOME/.bin ] && mkdir $HOME/.bin
if ! grep -q '$HOME/.bin:$PATH' ~/.zshrc ; then
  {
    echo ''
    echo 'export PATH=$HOME/.bin:$PATH'
  } >> ~/.zshrc
fi
echo "Done"

echo
# Restoring private backed up application and personal config files from cloud
sh utils/mackup.sh --restore

echo
# Configure ssh keys
sh utils/ssh-keys.sh $GIT_USER_EMAIL

echo
# Install user apps from cloud backup
sh utils/user-apps.sh

echo
# Install JDK
sh utils/sdk.sh -jdk

# echo
# Install Node & NPM
# sh utils/sdk.sh -nvm

echo
echo "Configuring Git..."
if test $(which git); then
  git config --global init.defaultBranch main
  git config --global core.editor $(which vi)
  git config --global credential.helper store
  git config --global merge.tool diffmerge
  git config --global merge.conflictstyle diff3
  git config --global mergetool.prompt false
  git config --global alias.co checkout
  git config --global alias.ci commit
  git config --global alias.br branch
  git config --global alias.st status
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
  git config --global alias.tree "log --graph --full-history --all --color --date=short --pretty=format:'%Cred%x09%h %Creset%ad%Cblue%d %Creset %s %C(bold)(%an)%Creset'"
  [[ ! -z ${GIT_USER_NAME} ]] && echo "Setting GitHub global user name: $GIT_USER_NAME" && git config --global user.name "$GIT_USER_NAME"
  [[ ! -z ${GIT_USER_EMAIL} ]] && echo "Setting GitHub global user email: $GIT_USER_EMAIL" && git config --global user.email "$GIT_USER_EMAIL"
  [[ -f ~/.ssh/id_github ]] && echo "Setting GitHub global access protocol: ssh" && git config --global url."git@github.com:".insteadOf "https://github.com/"
fi

echo
# Clone user's projects from version control
sh utils/projects.sh

echo
echo "Enabling installed services... \c"
  # [ -e "/Applications/Amphetamine.app" ] && open /Applications/Amphetamine.app
  # [ -e "/Applications/Magnet.app" ] && open /Applications/Magnet.app
  # [ -e "/Applications/Alfred\ 4.app" ] && open /Applications/Alfred\ 4.app
  # [ -e "/Applications/Gas\ Mask.app" ] && open /Applications/Gas\ Mask.app
  if test $(command -v syncthing); then brew services start syncthing &>/dev/null; fi
echo "Done"

echo
echo "${YELLOW}Thanks for using DevMyMacX!${NC}"
echo "${YELLOW}If you liked it, make sure to go to the GitHub repo (https://github.com/shubhamgulati91/DevMyMacX) and star it!${NC}"
echo "${YELLOW}If you have any issues, just put them there. All suggestions and contributions are appreciated!${NC}"

echo
echo "${RED}Some changes will be applied after closing this terminal window and logging off the user.${NC}"
