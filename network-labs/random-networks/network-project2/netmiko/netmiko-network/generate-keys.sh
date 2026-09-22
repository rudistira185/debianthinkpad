#/bin/bash

mkdir -p netmiko-keys
ssh-keygen -t ed25519 -f netmiko-keys/id_ed25519
