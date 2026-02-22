#!/bin/bash

set -euo pipefail

# ===== ANSI COLORS =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color


if command -v clab > /dev/null; then
echo -e "${GREEN}(INFO) containerlab already available ${NC}"
exit 0
else
echo -e "${YELLOW}(INFO) trying to install containerlab...... ${NC}"
sleep 1
bash -c "$(curl -sL https://get.containerlab.dev)"
sudo usermod -aG clab_admins" $USER"
newgrp clab_admins
fi
