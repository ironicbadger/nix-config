#!/bin/sh

nix build .#darwinConfigurations.slartibartfast.system #--extra-experimental-features "nix-command flakes"