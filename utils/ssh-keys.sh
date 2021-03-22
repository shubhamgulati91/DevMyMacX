#!/bin/sh

USER_EMAIL=$1
if [ -z "${USER_EMAIL}" ]; then
    echo "Enter your email"; read -n 50 -p "--> " USER_EMAIL; echo
fi

eval "$(ssh-agent -s)" &>/dev/null

if [ ! -f ~/.ssh/config ];  then
    echo "Creating new ssh config file... \c"
    {
        echo 'Host *'
        echo '  AddKeysToAgent yes'
        echo '  UseKeychain yes'
    } >> ~/.ssh/config
    echo "Done"
fi

configure_ssh_key() {
    SERVICE=$1
    KEY_ID=$2
    EMAIL=$3
    echo "Configuring ssh key for $SERVICE... \c"
    if [ ! -f ~/.ssh/$KEY_ID ];  then
        echo "Generating new key... \c"
        ssh-keygen -t ed25519 -C "$EMAIL" -N '' -f ~/.ssh/$KEY_ID <<< ""$'\n'"y" &>/dev/null
    else
        echo "Using existing key... \c"
    fi
    echo "Adding identity... \c"
    ssh-add ~/.ssh/$KEY_ID &>/dev/null
    if ! grep -Fq "IdentityFile ~/.ssh/$KEY_ID" ~/.ssh/config; then echo "  IdentityFile ~/.ssh/$KEY_ID" >> ~/.ssh/config; fi
    echo "Setting permissions... \c"
    chmod u=rw,go= ~/.ssh/$KEY_ID &>/dev/null
    chmod u=rw,go=r ~/.ssh/$KEY_ID.pub &>/dev/null
    echo "Done"
}

configure_ssh_key Default id_default $USER_EMAIL
configure_ssh_key GitHub id_github $USER_EMAIL
configure_ssh_key Mozilla id_mozilla $USER_EMAIL

echo
echo "Settings permissions for user's .ssh directory... \c"
chmod u=rwx,go= ~/.ssh &>/dev/null
chmod u=rw,go=r ~/.ssh/authorized_keys &>/dev/null
chmod u=rw,go=r ~/.ssh/known_hosts &>/dev/null
chmod u=rw,go=r ~/.ssh/config &>/dev/null
echo "Done"

echo "Settings permissions for user's .aws directory... \c"
chmod u=rwx,go= ~/.aws &>/dev/null
chmod u=r,go= ~/.aws/*.pem &>/dev/null
echo "Done"
