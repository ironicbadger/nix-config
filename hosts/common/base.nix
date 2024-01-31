{ lib, inputs, stablePkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-stable;
in
{
  programs.zsh = {
    enable = true;
  };
}
