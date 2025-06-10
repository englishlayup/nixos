#!/usr/bin/env bash
set -e
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    exit 0
fi
nixfmt . &>/dev/null \
  || ( nixfmt . ; echo "formatting failed!" && exit 1)
git diff -U0 ./*.nix
echo "NixOS Rebuilding..."
# shellcheck disable=SC2024
sudo nixos-rebuild switch --flake "$PWD" &>nixos-switch.log || (
grep --color error < nixos-switch.log  && exit 1)
current=$(nixos-rebuild list-generations | grep current)
git commit -am "$current"
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
