# nix-testing


```
# builds a target on a remote nixos host
nixos-rebuild switch --flake .#testnix --target-host testnix --build-host testnix --fast
```