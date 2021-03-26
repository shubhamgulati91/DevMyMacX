#!/bin/sh

# Input variables
CUSTOM_ICONS_LOCATION=${1}

# Script variables
DEFAULT_CUSTOM_ICONS_LOCATION=$(dirname "$0")/../icons

[ -z "${CUSTOM_ICONS_LOCATION}" ] && CUSTOM_ICONS_LOCATION=$DEFAULT_CUSTOM_ICONS_LOCATION

echo "Setting custom folder icons... "
if ! test $(which folderify); then
    echo "Maybe try installing folderify first."
    exit 1
fi

if [[ ! -d "${CUSTOM_ICONS_LOCATION}" ]]; then
    echo "Custom icons do not exist at $CUSTOM_ICONS_LOCATION."
    exit 1
fi

folderify_me () {
    ICON=$1
    DIR=$2
    if ! test -d "$DIR" ; then
        echo "Dir not found: $DIR..."
    elif ! test -f "$CUSTOM_ICONS_LOCATION/$ICON" ; then
        echo "Icon not found: $CUSTOM_ICONS_LOCATION/$ICON ..."
    else
        echo "Setting custom folder icon $ICON for $DIR... \c"
        # rm $DIR/Icon? &>/dev/null
        [ ! -f "$DIR"/Icon? ] && folderify "$CUSTOM_ICONS_LOCATION/$ICON" "$DIR" &>/dev/null
        echo "Done"
    fi
}

folderify_me google-drive.png $HOME/Google\ Drive
folderify_me iCloud-drive.png $HOME/Library/Mobile\ Documents/com~apple~CloudDocs
folderify_me syncthing.png $HOME/Sync

folderify_me code.png $HOME/Developer/Code
folderify_me projects.png $HOME/Developer/Projects
folderify_me archive.png $HOME/Developer/Projects/Archive
folderify_me current.png $HOME/Developer/Projects/Current
folderify_me source.png $HOME/Developer/Source
folderify_me bitbucket.png $HOME/Developer/Source/Bitbucket
folderify_me github.png $HOME/Developer/Source/GitHub
folderify_me gitlab.png $HOME/Developer/Source/GitLab

folderify_me jetbrains-intellij.png $HOME/Developer/Projects/IntelliJIDEA
folderify_me jetbrains-datagrip.png $HOME/Developer/Projects/DataGrip
folderify_me jetbrains-webstorm.png $HOME/Developer/Projects/WebStorm
folderify_me vscode.png $HOME/Developer/Projects/VSCode
folderify_me postman.png $HOME/Developer/Projects/Postman
folderify_me iMovie.png $HOME/Developer/Projects/iMovie

[ -d "$HOME/Projects" ] && rm -f "$HOME/Projects"
[ -d "$HOME/Developer/Projects/Current" ] && ln -s "$HOME/Developer/Projects/Current" "$HOME/Projects"

[ -d "$HOME/iCloud Drive" ] && rm -f "$HOME/iCloud Drive"
[ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ] && ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/iCloud Drive"
