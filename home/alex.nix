{ config, inputs, pkgs, lib, unstablePkgs, ... }:
{
  home.stateVersion = "23.11";

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  # aerospace config
  # home.file = lib.mkMerge [
  #   (lib.mkIf pkgs.stdenv.isDarwin {
  #     ".config/aerospace/aerospace.toml".text = builtins.readFile ./aerospace/aerospace.toml;
  #   })
  # ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--color=auto"
    ];
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
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
        rebase = true;
      };
    };
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lf.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = pkgs.lib.importTOML ./starship/starship.toml;
  };

  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    #initExtra = (builtins.readFile ../mac-dot-zshrc);
  };

  programs.tmux = {
    enable = true;
    #keyMode = "vi";
    clock24 = true;
    historyLimit = 10000;
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
      vim-tmux-navigator
    ];
    extraConfig = ''
      new-session -s main
      bind-key -n C-a send-prefix
    '';
  };

  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  programs.alacritty.enable = true;

  programs.bat.enable = true;
  programs.bat.config.theme = "Nord";
  #programs.zsh.shellAliases.cat = "${pkgs.bat}/bin/bat";

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      ## regular
      comment-nvim
      lualine-nvim
      nvim-web-devicons
      vim-tmux-navigator

      ## with config
      # {
      #   plugin = gruvbox-nvim;
      #   config = "colorscheme gruvbox";
      # }

      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin";
      }

      ## telescope
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./nvim/plugins/telescope.lua;
      }
      telescope-fzf-native-nvim

    ];
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymap.lua}
    '';
  };

  programs.zoxide.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
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
        hostname = "100.88.250.125";
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
