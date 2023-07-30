{ config, pkgs, lib, ... }:

{
    home.stateVersion = "23.05";

    # list of programs
    # https://mipmip.github.io/home-manager-option-search

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };

    programs.git = {
      enable = true;
      userEmail = "alexktz@gmail.com";
      userName = "Alex Kretzschmar";
      delta.enable = true;
    };

    programs.htop = {
      enable = true;
      settings.show_program_path = true;
    };

    programs.exa.enable = true;
    programs.jq.enable = true;
    programs.neovim.enable = true;
    programs.tmux.enable = true;
    programs.zoxide.enable = true;

    home.packages = with pkgs; [
      #nerdfonts
      ansible
      bitwarden-cli
      coreutils
      esptool
      hub
      gh
      gnused
      docker
      hugo
      ipmitool
      mas # mac app store cli
      mc
      mosh
      neofetch
      nmap
      ripgrep
      skopeo
      smartmontools
      terraform
      tree
      watch
      wget
      wireguard-tools
      unzip
    ];
}