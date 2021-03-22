#!/bin/sh

# Input variables
OPERATION=$1
MACKUP_BACKUP_LOCATION=$2

# Script variables
DEFAULT_MACKUP_BACKUP_LOCATION=${HOME}/.Backup
DEFAULT_DOTFILES_REPO='https://github.com/shubhamgulati91/dotfiles'

check_installation () {
    if ! test $(which mackup); then
        echo "Maybe try installing mackup first."
        exit 1
    fi
}

backup () {
    MACKUP_BACKUP_LOCATION=${1}
    [ -z "${MACKUP_BACKUP_LOCATION}" ] && MACKUP_BACKUP_LOCATION=$DEFAULT_MACKUP_BACKUP_LOCATION
    if [[ ! -d "${MACKUP_BACKUP_LOCATION}" ]]; then
        mkdir -p "$MACKUP_BACKUP_LOCATION"
    fi
    echo "Backing up user's application config files to cloud at $MACKUP_BACKUP_LOCATION/Mackup using mackup... \c"
    check_installation
    curl -Ls $DEFAULT_DOTFILES_REPO/raw/main/macOS/mackup/mackup.cfg > ~/.mackup.cfg
    mackup -f backup &>/dev/null
    echo "Done"
}

restore () {
    MACKUP_BACKUP_LOCATION=${1}
    [ -z "${MACKUP_BACKUP_LOCATION}" ] && MACKUP_BACKUP_LOCATION=$DEFAULT_MACKUP_BACKUP_LOCATION
    if [[ ! -d "${MACKUP_BACKUP_LOCATION}" ]]; then
        echo "Mackup backup not found at $MACKUP_BACKUP_LOCATION"
        echo "Retry restore after mackup backup is downloaded from the cloud."
        exit 1
    fi
    echo "Restoring user's application config files from cloud at $MACKUP_BACKUP_LOCATION/Mackup using mackup... \c"
    check_installation
    curl -Ls $DEFAULT_DOTFILES_REPO/raw/main/macOS/mackup/mackup.cfg > ~/.mackup.cfg
    mackup -f restore &>/dev/null
    echo "Done"
}


while [[ "$#" -gt 0 ]]; do
    case $OPERATION in
        -b|--backup) backup $MACKUP_BACKUP_LOCATION; shift ;;
        -r|--restore) restore $MACKUP_BACKUP_LOCATION; shift ;;
        *) echo "$0: Unknown parameter passed: $OPERATION"; exit 1 ;;
    esac
    shift
done
