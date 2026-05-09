# Build the system config and switch to it when running `just` with no args
default: switch

hostname := `hostname | cut -d "." -f 1`

### macos
# Build role. Use proxmox-template for the Proxmox VMA image; otherwise defaults to this Mac.
[macos]
build role=hostname flags="":
  #!/usr/bin/env bash
  set -euo pipefail
  case "{{role}}" in
    proxmox-template)
      echo "Building proxmox-template."
      scripts/proxmox-template/build {{flags}}
      ;;
    *)
      echo "Building nix-darwin config for {{role}}."
      nix --extra-experimental-features 'nix-command flakes' build ".#darwinConfigurations.{{role}}.system" {{flags}}
      ;;
  esac

# Build the nix-darwin config with the --show-trace flag set
[macos]
trace role=hostname: (build role "--show-trace")

# Build the current nix-darwin configuration and switch to it
[macos]
switch: (build hostname)
  @echo "switching to new config for {{hostname}}"
  sudo ./result/sw/bin/darwin-rebuild switch --flake ".#{{hostname}}"

### linux
# Build role. Use proxmox-template for the Proxmox VMA image; otherwise defaults to this NixOS host.
[linux]
build role=hostname flags="":
  #!/usr/bin/env bash
  set -euo pipefail
  case "{{role}}" in
    proxmox-template)
      echo "Building proxmox-template (Proxmox VMA image) locally."
      nix --extra-experimental-features 'nix-command flakes' build \
        .#nixosConfigurations.proxmox-template.config.system.build.image {{flags}}
      echo "OK: proxmox-template image build completed."
      echo "Artifact output is linked at ./result."
      ;;
    *)
      nixos-rebuild build --flake .#{{role}} {{flags}}
      ;;
  esac

# Build the NixOS config with the --show-trace flag set
[linux]
trace role=hostname: (build role "--show-trace")

# Build the current NixOS configuration and switch to it.
[linux]
switch:
  sudo nixos-rebuild switch --flake .#{{hostname}}

## colmena
cbuild:
  colmena build

capply:
  colmena apply

# Update flake inputs to their latest revisions
update:
  nix flake update

## CI command group. Run `just ci help` for subcommands.
ci *ARGS:
  scripts/ci {{ARGS}}

## remote nix vm installation
install IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    if [ -d \"nix-config\" ]; then \
        rm -rf nix-config; \
    fi && \
    git clone https://github.com/ironicbadger/nix-config.git && \
    cd nix-config/lib/install && \
    sh install-nix.sh\"'"


# Garbage collect old OS generations and remove stale packages from the nix store
gc:
  nix-collect-garbage -d
  nix-collect-garbage --delete-older-than 7d
  nix-store --gc

## manual command for initial bootstrapping
## sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
## nix --extra-experimental-features 'nix-command flakes' run nixpkgs#just
