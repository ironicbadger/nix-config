{ config, pkgs, lib, ... }:

{
    home.stateVersion = "23.05";

    programs.htop.enable = true;
    programs.htop.settings.show_program_path = true;

    home.packages = with pkgs; [
      mosh
      neovim
      nerdfonts
      pkgs.docker
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