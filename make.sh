#!/bin/bash

set -e
set -o pipefail
# set -x

OS=$(uname -s)
TARGET_OS="linux"
if [ "$OS" = "Darwin" ]; then
    TARGET_OS="macos"
elif [ "$OS" = "Linux" ] && [ -f "/etc/NIXOS" ]; then
    TARGET_OS="nixos"
fi

HOSTNAME=$(hostname | cut -d "." -f 1)

build() {
  local trace=$1
  case "$TARGET_OS" in
    "macos")
      echo "Building nix-darwin config ..."
      nix --extra-experimental-features 'nix-command flakes' build ".#darwinConfigurations.${HOSTNAME}.system" ${trace:+"$trace"}
      ;;
    "nixos")
      echo "Building NixOS config ..."
      nixos-rebuild build --flake ".#${HOSTNAME}" ${trace:+"$trace"}
      ;;
    "linux")
      echo "Building home-manager config..."
      nix build ".#homeManagerConfigurations.${HOSTNAME}.activationPackage" ${trace:+"$trace"}
      ;;
  esac
}

trace() {
  build "--show-trace"
}

switch() {
  build
  case "$TARGET_OS" in
    "macos")
      echo "Switching nix-darwin config ..."
      ./result/sw/bin/darwin-rebuild switch --flake ".#${HOSTNAME}"
      ;;
    "nixos")
      echo "Switching NixOS config ..."
      sudo nixos-rebuild switch --flake ".#${HOSTNAME}"
      ;;
    "linux")
      echo "Applying home-manager config..."
      ./result/activate
      ;;
  esac
}

update() {
    echo "Updating flake inputs..."
    nix flake update
}

gc() {
    echo "Garbage collecting..."
    nix-env --delete-generations 5d
    nix-store --gc
}

case "$1" in
    "build") build;;
    "trace") trace;;
    "switch") switch;;
    "update") update;;
    "gc") gc;;
    *) switch;;
esac
