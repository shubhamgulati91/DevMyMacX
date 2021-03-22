#!/bin/sh

# Input variables
OPERATION=$1

accept_xcode_license() {
    echo "Checking for XCode"
    if test $(which xcodebuild); then
        echo "Accept XCode license"
        sudo xcodebuild -license accept &>/dev/null
        [ $? -eq 0 ] && echo "Done"
    else
        echo "XCode not found"
    fi
}

brew_mas() {
    echo "Installing mas"
    [ -e "/Applications/Xcode.app" ] && brew install mas &>/dev/null
    [ -e "/Applications/Xcode.app" ] && [ $? -ne 0 ] && brew install --build-from-source mas &>/dev/null
    if [ $? -eq 0 ]; then echo "Done"; else echo "mas not installed"; fi
}

while [[ "$#" -gt 0 ]]; do
    case $OPERATION in
        -xcode|--accept-xcode-license) accept_xcode_license; shift ;;
        -mas|--brew-mas) brew_mas; shift ;;
        *) echo "$0: Unknown parameter passed: $OPERATION"; exit 1 ;;
    esac
    shift
done
