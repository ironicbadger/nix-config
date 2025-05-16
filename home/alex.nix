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

  programs.gpg.enable = true;

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
    defaultOptions = [
      "--no-mouse"
    ];
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
      # ~/.ssh/config
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
      };
      "*" = {
        user = "root";
      };
      # wd
      "dev" = {
        hostname = "100.68.216.79";
        user = "alex";
      };
      # lancs
      # "e elrond" = {
      #   hostname = "100.117.223.78";
      #   user = "alexktz";
      # };
      # # jb
      # "core" = {
      #   hostname = "demo.selfhosted.show";
      #   user = "ironicbadger";
      #   port = 53142;
      # };
      # "status" = {
      #   hostname = "hc.ktz.cloud";
      #   user = "ironicbadger";
      #   port = 53142;
      # };
    };
  };
}
