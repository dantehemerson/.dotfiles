#!/bin/bash

~/.dotfiles/setup/install/apt.sh
~/.dotfiles/setup/installers/common.installers.sh

~/.dotfiles/common/link_files.sh

~/.dotfiles/setup/postinstall/start-background-services.sh

~/.dotfiles/setup/installers/ssh-key-generator/ssh-key-generator.sh
