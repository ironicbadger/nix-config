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
    enableZshIntegration = true;
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
  programs.neovim.enable = true;
  programs.nix-index.enable = true;
  programs.zoxide.enable = true;
  #programs.zsh = true; # must be in darwin-config

  home.packages = with pkgs; [
    #nerdfonts
    ansible
    asciinema
    bitwarden-cli
    coreutils
    # direnv # programsn.direnv
    docker
    du-dust
    dua
    duf
    esptool
    ffmpeg
    hub
    fd
    #fzf # programs.fzf
    #git # programs.git
    gh
    gnused
    #htop # programs.htop
    hub
    hugo
    ipmitool
    jetbrains-mono # font
    jq
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
    unzip
    watch
    wget
    wireguard-tools
  ];
}