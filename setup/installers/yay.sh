#!/usr/bin/env bash

if ! command -v yay >/dev/null 2>&1; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
fi
