{ config, pkgs, lib, ... }:

{
    home.stateVersion = "23.05";

    programs.htop.enable = true;
    programs.htop.settings.show_program_path = true;

    programs.git = {
      enable = true;
      userEmail = "alexktz@gmail.com";
      userName = "Alex Kretzschmar";
    };

    home.packages = with pkgs; [
      mosh
      neovim
      nerdfonts
      pkgs.direnv
      pkgs.docker
      pkgs.git
      pkgs.hugo
      pkgs.jq
      pkgs.neofetch
      pkgs.nmap
      pkgs.ripgrep
      pkgs.terraform
      pkgs.tmux
      pkgs.tree
      pkgs.unzip
      pkgs.wget
    ];
}