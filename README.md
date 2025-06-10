# NixOS

## Fresh system

1. Install NixOS
1. Clone this repo
1. Run

```
sudo nixos-rebuild switch --flake ./
```

Optionally, clean up system versions older than 15 days:

```sh
sudo nix-collect-garbage --delete-older-than 15d
```

After each change, run `./rebuild.sh` to update system.
