{ unstablePkgs, stablePkgs, ... }:
let
  darwinPathOverrides = [
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    "/Applications/Postgres.app/Contents/Versions/latest/bin"
  ];
  pathOverrides = stablePkgs.lib.lists.optionals stablePkgs.stdenv.isDarwin darwinPathOverrides ++ [
    # We should figure out why we have to set the nix profile paths ourselves here
    "/etc/profiles/per-user/$USER/bin"
    "/run/current-system/sw/bin"
    "$HOME/.cargo/bin"
    "$HOME/bin"
    "$PATH"
  ];
in
{
  imports = [
    ./programs/zsh.nix
  ];
  home.stateVersion = "23.05";

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  home.sessionVariables = {
    EDITOR = "nvim";
    # This breaks vim in non tmux terminal on WSL
    # TERM = "screen-256color";
    DEFAULT_USER = "dominik";
    BUNDLER_EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    PATH = (builtins.concatStringsSep ":" pathOverrides);
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.gh = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns=5000"
      "--max-columns-preview"
      "--type-add"
      "ruby:*.{haml,feature,scss,coffee}*"
      "--smart-case"
      "--glob=!vendor"
      "--glob=!log"
      "--glob=!tmp"
      "--glob=!doc"
      "--glob=!coverage"
      "--glob=!.cargo"
      "--glob=!.git"
      "--hidden"
    ];
  };

  programs.git = {
    enable = true;
    delta.enable = true;
    lfs.enable = true;
    userEmail = "git@dsander.de";
    userName = "Dominik Sander";
    extraConfig = {
      push.default = "simple";
      fetch.prune = true;
      rebase.autoStash = true;
      mrge.ff = "only";
      init.templateDir = "~/.git_template";
      # color.ui = true; # We probably want the default of auto
    };
    aliases = {
      co = "checkout";
      ec = "config --global -e";
      up = "!git pull --rebase --prune $@ && git submodule update --init --recursive";
      cob = "checkout -b";
      cm = "!git add -A && git commit -m";
      save = "!git add -A && git commit -m 'SAVEPOINT'";
      wip = "!git add -u && git commit -m 'WIP'";
      undo = "reset HEAD~1 --mixed";
      amend = "commit -a --amend";
      wipe = "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard";
      bclean = "!f() { git branch --merged \${1-master} | grep -v \" \${1-master}$\" | xargs -r git branch -d; }; f";
      bdone = "!f() { git checkout \${1-master} && git up && git bclean \${1-master}; }; f";
      wdiff = "diff --color-words";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      dc = "diff --cached";
      pushb = "!git push --set-upstream origin `git rev-parse --abbrev-ref HEAD`";
      branch-history = "for-each-ref --sort=committerdate refs/heads/ --format='%(color: yellow)%(committerdate:short) %(color: cyan)%(refname:short)  %(color: reset)%(subject)'";
    };
    ignores = [
      ".DS_Store"
      "*.sw[nop]"
      ".bundle"
      ".byebug_history"
      ".env"
      "db/*.sqlite3"
      "log/*.log"
      "rerun.txt"
      "tags"
      "!tags/"
      "tmp/**/*"
      "!tmp/cache/.keep"
      "*.pyc"
      ".project-notes"
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # nvim plugin providers
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    extraConfig = ''
      set runtimepath+=~/.vim,~/.vim/after
      set packpath+=~/.vim
      source ~/.vimrc
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = (builtins.readFile ./config/tmux.conf);
  };

  programs.atuin = {
    enable = true;
    package = unstablePkgs.atuin;
  };

  home.file = {
    # hammerspoon = lib.mkIf pkgs.stdenvNoCC.isDarwin {
    #   source = ./hammerspoon;
    #   target = ".hammerspoon";
    #   recursive = true;
    # };
    vim = {
      source = ./config/vim;
      target = ".vim";
      recursive = true;
    };
    vimrc = {
      source = ./config/vimrc;
      target = ".vimrc";
    };
    pgclirc = {
      source = ./config/pgclirc;
      target = ".pgclirc";
    };
    # npmrc = {
    #   text = ''
    #     prefix = ${config.home.sessionVariables.NODE_PATH};
    #   '';
    #   target = ".npmrc";
    # };
  };

  programs.home-manager.enable = true;
  home.packages = with stablePkgs; [
    # bash
  ];
}

