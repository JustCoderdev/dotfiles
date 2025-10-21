```
nix run github:nix-community/nixos-anywhere -- \
        --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
        --flake .#wise --target-host root@<ip address>
```
