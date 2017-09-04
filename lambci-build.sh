#!/bin/sh

set -e

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install git ruby openssh-client
git clone https://github.com/josephbisch/bitcoin.git -b gitian-script-fixes
bash ./bitcoin/contrib/gitian-build.sh --verify --build --os l --setup --no-commit signer 0.14.2
