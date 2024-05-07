{ config, pkgs, lib, unstablePkgs, ... }:
{
  home.stateVersion = "23.11";

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
    diff-so-fancy.enable = true;
    lfs.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictStyle = "diff3";
          tool = "meld";
        };
        pull = {
          rebase = false;
        };
      };
    }; # end git

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lf.enable = true;

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = ''
  #     set fish_greeting # Disable greeting
  #   '';
  #   plugins = [{
  #       name="foreign-env";
  #       src = pkgs.fetchFromGitHub {
  #           owner = "oh-my-fish";
  #           repo = "plugin-foreign-env";
  #           rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
  #           sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
  #       };
  #   }];
  # };

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

  # exa deprecated
  #programs.exa.enable = true;
  #programs.exa.enableAliases = true;

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
      "dt deepthought" = {
        hostname = "deepthought";
        user = "root";
      };
      "m morpheus" = {
        hostname = "morpheus";
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
        hostname = "100.118.52.61";
        user = "root";
      };
      # nr
      "p pennywise" = {
        hostname = "100.88.250.125";
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
}