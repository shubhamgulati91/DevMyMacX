#!/bin/sh

# Color variables
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export NC='\033[0m'

# Input variables
SETUP_STATE=$1
SETUP_MODE=$2
SETUP_PACKAGE=$3

DEFAULT_SETUP_STATE='i'
DEFAULT_SETUP_MODE='m'
DEFAULT_SETUP_PACKAGE='l'

# Script variables
DEFAULT_SETUP_REPO='https://github.com/shubhamgulati91/DevMyMacX'
DEFAULT_SETUP_REPO_BRANCH=main
BOOTSTRAP_SCRIPT="$DEFAULT_SETUP_REPO/raw/$DEFAULT_SETUP_REPO_BRANCH/bootstrap.sh"

DEFAULT_SETUP_CHECKOUT_DIR_DEV="$HOME/Developer/Projects/Current/DevMyMacX"
DEFAULT_SETUP_CHECKOUT_DIR_USER="/tmp/DevMyMacX"
DEFAULT_SETUP_CHECKOUT_DIR=$DEFAULT_SETUP_CHECKOUT_DIR_USER

restart_bootstrapper() {
    clear
    echo "Restarting bootstrapper..."

    echo "Choose setup state? [default: ${BLUE}$DEFAULT_SETUP_STATE${NC}] [i] initialize / [u] update"; read -n 1 -sp "--> " SETUP_STATE ; [ -z "${SETUP_STATE}" ] && SETUP_STATE=$DEFAULT_SETUP_STATE; echo ${GREEN}$SETUP_STATE${NC}; echo
    echo "Choose setup mode? [default: ${BLUE}$DEFAULT_SETUP_MODE${NC}] [m] manual / [a] automatic"; read -n 1 -sp "--> " SETUP_MODE ; [ -z "${SETUP_MODE}" ] && SETUP_MODE=$DEFAULT_SETUP_MODE; echo ${GREEN}$SETUP_MODE${NC}; echo

    if [[ ${SETUP_MODE} =~ ^[Aa]$ ]]; then
        echo "Choose automatic setup package? [default: ${BLUE}$DEFAULT_SETUP_PACKAGE${NC}] [l] lean / [e] express / [f] full"; read -n 1 -sp "--> " SETUP_PACKAGE ; [ -z "${SETUP_PACKAGE}" ] && SETUP_PACKAGE=$DEFAULT_SETUP_PACKAGE; echo ${GREEN}$SETUP_PACKAGE${NC}; echo
    fi

    if [ -d $DEFAULT_SETUP_CHECKOUT_DIR ]; then
        sh $DEFAULT_SETUP_CHECKOUT_DIR/bootstrap.sh -${SETUP_STATE} -${SETUP_MODE} -${SETUP_PACKAGE}
    else
        sh -c "$(curl -fsSL $BOOTSTRAP_SCRIPT)" "" -${SETUP_STATE} -${SETUP_MODE} -${SETUP_PACKAGE}
    fi
}

checkout_setup() {
    CHECKOUT_DIR=$1
    [ -z "${CHECKOUT_DIR}" ] && CHECKOUT_DIR=$DEFAULT_SETUP_CHECKOUT_DIR
    if [ ! -d "${CHECKOUT_DIR}" ]; then
        echo "Cloning setup to $CHECKOUT_DIR... \c"
        git clone $DEFAULT_SETUP_REPO.git $CHECKOUT_DIR &>/dev/null
        cd $CHECKOUT_DIR
        echo "Checking out $DEFAULT_SETUP_REPO_BRANCH branch... \c"
        git checkout $DEFAULT_SETUP_REPO_BRANCH &>/dev/null
        echo "Done"
    else
        echo "Refreshing setup at $CHECKOUT_DIR... \c"
        cd $CHECKOUT_DIR
        git pull --ff-only &>/dev/null
        echo "Done"
    fi
}

confirm_action () {
    if [ ${DEFAULT_SETUP_REPO_BRANCH} = "dev" ]; then return; fi
    echo
    echo "${GREEN}Update your details in conf/user.properties file...${NC}"
    ENTER_KEY=return
    while true; do
        echo "Press ${GREEN}$ENTER_KEY${NC} key do it now or ${GREEN}q${NC} to exit now and re-run the setup later"; read -n 1 -sp "--> " PROMPT_RESPONSE
        [ ! -z "${PROMPT_RESPONSE}" ] && echo $PROMPT_RESPONSE
        [ -z "${PROMPT_RESPONSE}" ] && echo $ENTER_KEY && nano conf/user.properties && break
        if [[ ${PROMPT_RESPONSE} =~ ^[Qq]$ ]]; then exit 1; fi
    done
    unset PROMPT_RESPONSE
    while true; do
        echo "Press ${GREEN}$ENTER_KEY${NC} key again to confirm the edits or ${GREEN}q${NC} to exit now and re-run the setup later"; read -n 1 -sp "--> " PROMPT_RESPONSE
        [ ! -z "${PROMPT_RESPONSE}" ] && echo $PROMPT_RESPONSE
        [ -z "${PROMPT_RESPONSE}" ] && echo "return" && break
        if [[ ${PROMPT_RESPONSE} =~ ^[Qq]$ ]]; then exit 1; fi
    done
}

# Check if XCode Command line tools are installed
if ! (type xcode-select >&- && xpath=$( xcode-select --print-path ) && test -d "${xpath}" && test -x "${xpath}") ; then
    echo "${RED}Need to install the XCode Command Line Tools (or XCode) first! Starting install...${NC}"
    # Install XCode Command Line Tools
    xcode-select --install &>/dev/null
    exit 1
fi

case $SETUP_MODE in
    -a|--automatic) SETUP_MODE='a' ;;
    -d|--debug) SETUP_MODE='d' ;;
    -m|--manual|*) SETUP_MODE='m' ;;
esac
case $SETUP_PACKAGE in
    -f|--full) SETUP_PACKAGE='f' ;;
    -e|--express) SETUP_PACKAGE='e' ;;
    -l|--lean|*) SETUP_PACKAGE='l' ;;
esac

SETUP_CHECKOUT_DIR=$DEFAULT_SETUP_CHECKOUT_DIR
case $SETUP_STATE in
    -i|--initialize)
        echo "Launching setup initializer..."
        checkout_setup $SETUP_CHECKOUT_DIR;
        confirm_action;
        source utils/functions.sh && set_user_properties;
        sh ./init.sh -${SETUP_MODE} -${SETUP_PACKAGE} ;;
    -u|--update)
        echo "Launching setup updater..."
        checkout_setup $SETUP_CHECKOUT_DIR;
        confirm_action;
        source utils/functions.sh && set_user_properties;
        sh ./update.sh -${SETUP_MODE} -${SETUP_PACKAGE} ;;
    *)
        restart_bootstrapper ;;
esac
