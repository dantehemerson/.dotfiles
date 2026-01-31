#!/bin/bash

~/.dotfiles/setup/install/pacman.sh
~/.dotfiles/setup/installers/yay.sh
~/.dotfiles/setup/install/yay.sh

~/.dotfiles/setup/installers/common.installers.sh

~/.dotfiles/common/link_files.sh

~/.dotfiles/setup/installers/ssh-key-generator/ssh-key-generator.sh
