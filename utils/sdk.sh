#!/bin/sh

# Input variables
SDK=$1
SDK_VERSION=$2

setup_jdk () {
    JDK_VERSION=${1}
    echo "Setting up method to switch between different jdk versions... \c"
    if ! test $(which javac) || [ ! "$(ls /Library/Java/JavaVirtualMachines)" ]; then
        echo "Maybe install a jdk first."
        exit 1
    fi
    [ ! -f $HOME/.zshenv ] && touch $HOME/.zshenv
    if ! grep -Fq "jdk()" ~/.zshenv; then
        {
            echo ''
            echo 'jdk() {'
            echo '  jdk_version=$1'
            echo '  export JAVA_HOME=$(/usr/libexec/java_home -v"$jdk_version");'
            echo '  java -version'
            echo '}'
        } >> ~/.zshenv
    fi
    echo "Done"

    echo "List of JDK versions installed... \c"
    ls /Library/Java/JavaVirtualMachines
}

install_nvm () {
    NODE_VERSION=${1}
    echo "Installing nvm... \c"
    brew install nvm &>/dev/null
    [ ! -d $HOME/.nvm ] && mkdir $HOME/.nvm &>/dev/null
    if ! grep -q '. "/opt/homebrew/opt/nvm/nvm.sh"' ~/.zshrc; then
        {
            echo ''
            echo 'export NVM_DIR="$HOME/.nvm"'
            echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"'
            echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"'
        } >> ~/.zshrc
    fi
    echo "Done"

    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    eval $(/opt/homebrew/bin/brew shellenv) &>/dev/null
}

nvm_install_node () {
    NODE_VERSION=${1}
    if ! test $(command -v nvm); then install_nvm; fi
    echo "Intalling node\c"
    if [[ ${NODE_VERSION} = "lts" ]]; then
        echo " lts version through nvm... \c"
        nvm install --lts &>/dev/null
        # nvm use --lts &>/dev/null
    else
        echo " current version through nvm... \c"
        nvm install node &>/dev/null
        # nvm use node &>/dev/null
    fi

    echo "Clearing nvm cache... \c"
    nvm cache clear &>/dev/null

    echo "Done"

    echo "List of node versions installed... \c"
    ls $HOME/.nvm/versions/node

    # NPM Settings
    # npm config set loglevel warn &>/dev/null
}

install_node () {
    echo "Installing node current version... \c"
    brew install node &>/dev/null
    echo "Done"
}

install_node_lts () {
    NODE_LTS_VERSION=${1}
    echo "Installing node-lts version $NODE_LTS_VERSION ... \c"
    brew install node@$NODE_LTS_VERSION &>/dev/null
    brew link --overwrite node@$NODE_LTS_VERSION &>/dev/null
    echo "Done"
}


while [[ "$#" -gt 0 ]]; do
    case $SDK in
        -jdk|--java-development-kit) setup_jdk $SDK_VERSION; shift ;;
        -nvm|--node-version-manager) install_nvm; shift ;;
        -nvm-node|--node-version-manager-and-node) nvm_install_node $SDK_VERSION; shift ;;
        -brew-node|--brew-node-current) install_node; shift ;;
        -brew-node-lts|--brew-node-long-term-support) install_node_lts $SDK_VERSION; shift ;;
        *) echo "$0: Unknown parameter passed: $SDK"; exit 1 ;;
    esac
    shift
done
