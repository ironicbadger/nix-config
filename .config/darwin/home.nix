{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.05";
  #home.home = "/Users/alex";
  #home-manager.users.alex = { pkgs, ... }: {};

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

  programs.tmux = {
    enable = true;
    #keyMode = "vi";
    clock24 = true;
    historyLimit = 10000;
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
    ];
    extraConfig = ''
      new-session -s main
      bind-key -n C-a send-prefix
    '';
  };

  programs.exa.enable = true;
  programs.jq.enable = true;
  programs.neovim.enable = true;
  programs.nix-index.enable = true;
  programs.zoxide.enable = true;
  #programs.zsh = true; # must be in darwin-config

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
    jetbrains-mono # font
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