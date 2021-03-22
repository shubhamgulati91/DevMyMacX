#!/bin/sh

# Input variables
OPERATION=$1
FILE=$2
CLOUD_CONFIG_STORE_LOCATION=$3

# Default values
DEFAULT_CLOUD_CONFIG_STORE_LOCATION=${HOME}/Library/Mobile\ Documents/com\~apple\~CloudDocs/.backup

backup () {
    BACKUP_FILE=${1}
    BACKUP_LOCATION=${2}
    if [[ -z "${FILE}" ]]; then
        echo "Maybe also tell me what to backup."
        exit 1
    fi
    [ -z "${BACKUP_LOCATION}" ] && BACKUP_LOCATION=$DEFAULT_CLOUD_CONFIG_STORE_LOCATION
    if [[ ! -d "${BACKUP_LOCATION}" ]]; then
        mkdir -p "$BACKUP_LOCATION"
    fi

    echo "Backing up user's $BACKUP_FILE to cloud at $BACKUP_LOCATION ... \c"
    if [ -d "$BACKUP_FILE" ]; then
        [ ! -d "$BACKUP_LOCATION$BACKUP_FILE" ] && mkdir -p "$BACKUP_LOCATION$BACKUP_FILE"
        yes | cp -anfp "$BACKUP_FILE"/. "$BACKUP_LOCATION$BACKUP_FILE"/
    fi
    if [ -f "$BACKUP_FILE" ]; then
        [ ! -d "$BACKUP_LOCATION$(dirname "$BACKUP_FILE")" ] && mkdir -p "$BACKUP_LOCATION$(dirname "$BACKUP_FILE")"
        yes | cp -anfp "$BACKUP_FILE" "$BACKUP_LOCATION$(dirname "$BACKUP_FILE")"/
    fi
    echo "Done"
}

restore () {
    RESTORE_FILE=${1}
    RESTORE_LOCATION=${2}
    if [[ -z "${RESTORE_FILE}" ]]; then
        echo "Maybe also tell me what to restore."
        exit 1
    fi
    [ -z "${RESTORE_LOCATION}" ] && RESTORE_LOCATION=$DEFAULT_CLOUD_CONFIG_STORE_LOCATION
    if [[ ! -d "${RESTORE_LOCATION}" ]]; then
        echo "Backup does not exist at $RESTORE_LOCATION."
        exit 1
    fi

    echo "Restoring user's $RESTORE_FILE from cloud backup at $RESTORE_LOCATION ... \c"
    if [ -d "$RESTORE_LOCATION$FILE" ]; then
        [ ! -d "$RESTORE_FILE" ] && mkdir -p "$RESTORE_FILE"
        yes | cp -anfp "$RESTORE_LOCATION$RESTORE_FILE"/. "$RESTORE_FILE"/
    fi
    if [ -f "$RESTORE_LOCATION$RESTORE_FILE" ]; then
        [ ! -d $(dirname "$RESTORE_FILE") ] && mkdir -p $(dirname "$RESTORE_FILE")
        yes | cp -anfp "$RESTORE_LOCATION$RESTORE_FILE" $(dirname "$RESTORE_FILE")/
    fi
    echo "Done"
}


while [[ "$#" -gt 0 ]]; do
    case $OPERATION in
        -b|--backup) backup $FILE $CLOUD_CONFIG_STORE_LOCATION; shift ;;
        -r|--restore) restore $FILE $CLOUD_CONFIG_STORE_LOCATION; shift ;;
        *) echo "$0: Unknown parameter passed: $OPERATION"; exit 1 ;;
    esac
    shift
done
