#!/bin/bash

~/.dotfiles/setup/repos/debian.sh

~/.dotfiles/setup/install/apt.sh
bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
~/.dotfiles/common/link_files.sh
