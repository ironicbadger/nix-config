{ config, pkgs, lib, unstablePkgs, ... }:
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    #initExtra = (builtins.readFile ../mac-dot-zshrc);
  };

  programs.exa.enable = true;
  programs.exa.enableAliases = true;
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.nix-index.enable = true;
  programs.zoxide.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
    Host *
      StrictHostKeyChecking no
    '';
    matchBlocks = {
      # wd
      "m morpheus" = {
        hostname = "10.42.1.10";
        user = "alex";
      };
      "a anton" = {
        hostname = "10.42.1.20";
        user = "root";
      };
      "bricktop" = {
        hostname = "10.42.1.80";
        user = "pi";
      };
      "z zoidberg" = {
        hostname = "10.42.1.42";
        user = "root";
      };
      "m1" = {
        hostname = "10.42.1.30";
        user = "root";
      };
      "hl15" = {
        hostname = "10.42.1.51";
        user = "root";
      };
      "testnix" = {
        hostname = "10.42.0.50";
        user = "alex";
      };
      "opn opnwd" = {
        hostname = "10.42.0.254";
        user = "alexktz";
      };
      "pihole" = {
        hostname = "10.42.0.253";
        user = "root";
      };
      "caddy" = {
        hostname = "10.42.0.252";
        user = "root";
      };
      # nr
      "p pennywise" = {
        hostname = "192.168.16.10";
        user = "alex";
      };
      # lancs
      "e elrond" = {
        hostname = "100.117.223.78";
        user = "alexktz";
      };
      # ktz-cloud
      "cloud" = {
        hostname = "100.89.12.127";
        user = "ironicbadger";
      };
      # jb
      "core" = {
        hostname = "demo.selfhosted.show";
        user = "ironicbadger";
        port = 53142;
      };
      "status" = {
        hostname = "hc.ktz.cloud";
        user = "ironicbadger";
        port = 53142;
      };
    };
  };

  # home.packages = with pkgs; [
  #   ## unstable
  #   unstablePkgs.yt-dlp
  #   unstablePkgs.terraform

  #   ## stable
  #   ansible
  #   asciinema
  #   bitwarden-cli
  #   coreutils
  #   # direnv # programs.direnv
  #   #docker
  #   drill
  #   du-dust
  #   dua
  #   duf
  #   esptool
  #   ffmpeg
  #   fd
  #   #fzf # programs.fzf
  #   #git # programs.git
  #   gh
  #   go
  #   gnused
  #   #htop # programs.htop
  #   hub
  #   hugo
  #   ipmitool
  #   jetbrains-mono # font
  #   just
  #   jq
  #   mas # mac app store cli
  #   mc
  #   mosh
  #   neofetch
  #   nmap
  #   ripgrep
  #   skopeo
  #   smartmontools
  #   tree
  #   unzip
  #   watch
  #   wget
  #   wireguard-tools
  # ];
}