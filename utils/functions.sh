#!/bin/sh

# Variables
DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION=$HOME/.Backup

get_user_property () {
  PROPERTY_KEY=$1
  grep -w "^${PROPERTY_KEY}" conf/user.properties|cut -d'=' -f2
}

get_env_property () {
  PROPERTY_KEY=$1
  grep -w "^${PROPERTY_KEY}" conf/environment.properties|cut -d'=' -f2
}

set_bootstrap_properties () {
  export SETUP_STATE=$(get_env_property 'SETUP_STATE')
  export SETUP_MODE=$(get_env_property 'SETUP_MODE')
  export SETUP_PACKAGE=$(get_env_property 'SETUP_PACKAGE')
}

set_user_properties () {
  export DEFAULT_COMPUTER_NAME=$(get_user_property 'COMPUTER_NAME')
  export DEFAULT_HOSTNAME=$(get_user_property 'HOSTNAME')
  export DEFAULT_LOCAL_HOSTNAME=$(get_user_property 'LOCAL_HOSTNAME')
  export DEFAULT_GIT_USER_NAME=$(get_user_property 'GIT_USER_NAME')
  export DEFAULT_GIT_USER_EMAIL=$(get_user_property 'GIT_USER_EMAIL')
  export DEFAULT_DOTFILES_SRC=$(get_user_property 'DOTFILES_SRC')
  export DEFAULT_PRIVATE_DATA_BACKUP_REPO=$(get_user_property 'PRIVATE_DATA_BACKUP_REPO')

  export CURRENT_PROJECTS_DIR=$(get_user_property 'CURRENT_PROJECTS_DIR')
  export GITHUB_USERNAME=$(get_user_property 'GITHUB_USERNAME')
  export CHECKOUT_GITHUB_PROJECTS=$(get_user_property 'CHECKOUT_GITHUB_PROJECTS')
}

checkout_private_data_repository () {
  if [ ! -d "${DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION}" ]; then
    echo "Cloning user's private backup to $DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION..."
    echo
    git clone $PRIVATE_DATA_BACKUP_REPO $DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION
  else
    echo "User's private backup found at $DEFAULT_PRIVATE_DATA_CHECKOUT_LOCATION..."
  fi
}

install_bundle() {
  BREWFILE=$1
  INSTALL_BUNDLE=$2
  if [[ ${INSTALL_BUNDLE} =~ ^[Yy]$ ]]; then
      curl -Ls $BREWFILES_SRC/$BREWFILE > $DEFAULT_BREWFILES_CHECHOUT_LOCATION/$BREWFILE
      [[ ${EDIT_BREWFILES} =~ ^[Yy]$ ]] && nano $DEFAULT_BREWFILES_CHECHOUT_LOCATION/$BREWFILE
      echo
      echo "Installing ${GREEN}$BREWFILE${NC}... "
      brew bundle --file=$DEFAULT_BREWFILES_CHECHOUT_LOCATION/$BREWFILE
  fi
}