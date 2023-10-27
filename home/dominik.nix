{ config, pkgs, lib, unstablePkgs, ... }:
{
  home.stateVersion = "23.05";

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # We need this for the env setup, but can't do it at the moment because dot files are managed by rcm
  # Scratch that even with this enabled /run/current-system/sw/bin isn't in the PATH, this is how it always treats us :/
  # programs.zsh.enable = true;
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    duf
  ];
}
