#!/bin/bash

### -------------------
### Uncomment ll command in bashrc
### -------------------

sed -i -e "s/#alias ll='ls -l'/alias ll='ls -al'/g" ~/.bashrc
. $HOME/.bashrc


### -------------------
### Pre-requisites for running Goose
### -------------------

sudo apt update && sudo apt install -y \
  gnome-keyring \
  dbus-x11 \
  libsecret-1-0 \
  libsecret-1-dev \
  libsecret-tools

mkdir -p ~/.local/share/keyrings
touch ~/.local/share/keyrings/login.keyring
eval $(dbus-launch)
export $(dbus-launch)
gnome-keyring-daemon --start --components=secrets
echo "blah" | gnome-keyring-daemon -r --unlock --components=secret

## Pinning down specific version
# GOOSE_RELEASE="stable"
GOOSE_RELEASE="v1.43.0"
curl -fsSL https://github.com/aaif-goose/goose/releases/download/${GOOSE_RELEASE}/download_cli.sh | bash