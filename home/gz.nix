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

  # Neovim configuration files
  xdg.configFile = {
    "nvim/lua/options.lua".source = ./nvim/options.lua;
    "nvim/lua/keymap.lua".source = ./nvim/keymap.lua;
    "nvim/init.lua".text = ''
      -- Load options
      require("options")
      
      -- Load keymaps
      require("keymap")
    '';
  };

  programs.gpg.enable = true;

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./config/vim/vimrc;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      fzf-vim
    ];
  };

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
      pull = {
        rebase = true;
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = pkgs.lib.importTOML ./starship/starship.toml;
  };

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    
    # Load the main config.fish file
    interactiveShellInit = builtins.readFile ./config/fish/config.fish;
    
    # Define Fish shell functions
    functions = {
      # Custom functions from your configuration
      e = "$EDITOR $argv";
      la = "ls -la";
      ll = "ls -l";
      o = "open $argv";
      gaa = "git add -A";
      gs = "git status";
      gf = "git fetch";
      myip = "curl -s https://api.ipify.org";
      rmssh = "rm ~/.ssh/known_hosts";
      sshrm = "rm ~/.ssh/known_hosts";
      vi = "vim $argv";
      
      # Bang-bang function (does not work in Vi mode)
      __history_previous_command = ''
        switch (commandline -t)
          case "!"
            commandline -t $history[1]; commandline -f repaint
          case "*"
            commandline -i !
        end
      '';
      
      # !$ Function
      __history_previous_command_arguments = ''
        switch (commandline -t)
          case "!"
            commandline -t ""
            commandline -f history-token-search-backward
          case "*"
            commandline -i '$'
        end
      '';
      
      # Directory renaming function
      rename_directories = ''
        for dir in (find . -maxdepth 1 -type d -not -name '.*' -not -name '#*' -not -name '@*' -print | sed 's|^\./||')
          # Skip the current directory
          if test "$dir" = "."; continue; end

          # Replace hyphens with spaces and capitalize each word
          set new_dir (echo $dir | string replace -a '-' ' ' | string titlecase)

          # Rename directory if the new name is different from the current name
          if test "$dir" != "$new_dir"
              echo "Renaming '$dir' to '$new_dir'"
              mv "$dir" "$new_dir"
          end
        end
      '';
    };
    
    # Fish shell plugins
    plugins = [
      # You can add Fish plugins here from pkgs.fishPlugins
      # Example: { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
    
    # Fish shell aliases
    shellAliases = {
      # Add your aliases here
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    #initExtra = (builtins.readFile ../mac-dot-zshrc);
  };

  programs.tmux = {
    enable = true;
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

  programs.alacritty.enable = false;

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
      # {
      #   plugin = nvim-tree-lua;
      #   config = "lua require('nvim-tree').setup()";
      # }
      # {
      #   plugin = telescope-nvim;
      #   config = "lua require('telescope').setup()";
      # }
      # {
      #   plugin = nvim-treesitter.withAllGrammars;
      #   config = "lua require('nvim-treesitter.configs').setup { highlight = { enable = true } }";
      # }
      # {
      #   plugin = nvim-lspconfig;
      #   config = "lua require('lspconfig').pyright.setup{}";
      # }
      telescope-nvim
      telescope-fzf-native-nvim

    ];
    extraConfig = ''" Neovim configuration"''; # Empty extraConfig to avoid syntax errors
  };

  programs.zoxide.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
  StrictHostKeyChecking no
  AddKeysToAgent yes
  UseKeychain yes
  IdentityAgent "/Users/${config.home.username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  XAuthLocation /opt/X11/bin/xauth
  
  Host github.com
    HostName github.com
    User sinistersoundworks
    PreferredAuthentications publickey
    IdentityFile "/Users/${config.home.username}/.ssh/sinistersoundworks-GitHub"
    
  Host fw
    HostName 10.30.10.1
    User gz
    '';
    # matchBlocks = {}; # Empty matchBlocks to avoid compatibility issues
    #   # lancs
    #   # "e elrond" = {
    #   #   hostname = "100.117.223.78";
    #   #   user = "alexktz";
    #   # };
    #   # # jb
    #   # "core" = {
    #   #   hostname = "demo.selfhosted.show";
    #   #   user = "ironicbadger";
    #   #   port = 53142;
    #   # };
    #   # "status" = {
    #   #   hostname = "hc.ktz.cloud";
    #   #   user = "ironicbadger";
    #   #   port = 53142;
    #   # };
  };
}
