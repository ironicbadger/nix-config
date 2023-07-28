{ config, pkgs, ... }:

with import <nixpkgs> { };
let
  #neovim = pkgs.callPackage ./nvim.nix { };
in
{
  environment.variables = { EDITOR = "vim"; };
  environment.systemPackages =
  [
    neovim
    nerdfonts
    pkgs.git
    pkgs.hugo
    pkgs.ibm-plex
    pkgs.jq
    pkgs.nmap
    pkgs.ripgrep
    pkgs.terraform
    pkgs.tmux
    pkgs.tree
    pkgs.unzip
    pkgs.wget
  ];
}