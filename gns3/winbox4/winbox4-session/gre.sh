#!/bin/bash

mkdir -p session-file
PROFILE="session-file/gre"

mkdir -p "$PROFILE"

HOME="$PROFILE" /home/selene/debianthinkpad/gns3/winbox4/winbox4
