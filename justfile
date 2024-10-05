build:
  colmena build

apply:
  colmena apply

gc HOST generations="5":
  #!/usr/bin/env sh
  ssh root@{{HOST}} cat /etc/hostname && \
    nix-env --delete-generations {{generations}} && \
    nix-store --gc && \
    nix-collect-garbage -d

# Garbage collect old OS generations and remove stale packages from the nix store
gclocal generations="5":
  nix-env --delete-generations {{generations}}
  nix-store --gc
  nix-collect-garbage -d