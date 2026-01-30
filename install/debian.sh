#!/bin/bash

~/.dotfiles/setup/install/apt.sh
bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
~/.dotfiles/common/link_files.sh
