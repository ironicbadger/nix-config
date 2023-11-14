{ config, pkgs, lib, unstablePkgs, ... }:
{
  home.stateVersion = "23.05";

  # list of programs
  # https://mipmip.github.io/home-manager-option-search

  home.sessionVariables = {
    EDITOR = "vim";
    # This breaks vim in non tmux terminal on WSL
    # TERM = "screen-256color";
    DEFAULT_USER = "dominik";
    BUNDLER_EDITOR = "vim";
    PATH = "/etc/profiles/per-user/$USER/bin/:/run/current-system/sw/bin:$HOME/.cargo/bin:$HOME/bin:$PATH";
    RIPGREP_CONFIG_PATH = "$HOME/.ripgreprc";
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


  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history = {
      extended = true;
      save = 100000000;
      size = 100000000;
      share = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
    localVariables = {
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [
        "context" # user@hostname
        "dir" # current directory
        "vcs" # git status
      ];
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = [
        "status" # exit code of the last command
        "command_execution_time" # duration of the last command
      ];
      POWERLEVEL9K_MODE = "nerdfont-complete";
      POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING = false;
      POWERLEVEL9K_VCS_GIT_ICON = "";
      POWERLEVEL9K_HOME_ICON = "";
      POWERLEVEL9K_HOME_SUB_ICON = "";
      POWERLEVEL9K_ETC_ICON = "";
    };
    shellAliases = {
      diffscreens = "cd ~/Dropbox/Screenshots && compare - density 300 \"`ls -tr | tail -2|head -1`\" \"`ls -tr | tail -1`\" - compose src diff.png; open diff.png";
      mux = "tmuxinator";
      nhssh = "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no";
      nhscp = "scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no";
      cleanup = "find . -name '*.DS_Store' -type f -ls -delete";
      vim = "nvim";
    };
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block, everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      setopt incappendhistory
      setopt promptsubst

      # handy keybindings
      bindkey "^s" beginning-of-line
      bindkey "^e" end-of-line
      bindkey "^f" forward-char
      bindkey "^b" backward-char
      bindkey "^k" kill-line
      bindkey "^d" delete-char
      bindkey "^p" history-search-backward
      bindkey "^n" history-search-forward
      bindkey "^y" accept-and-hold
      bindkey "^w" backward-kill-word
      bindkey "^u" backward-kill-line
      bindkey "\e[3~" delete-char

      # Use vim keys in tab complete menu:
      zmodload -i zsh/complist
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history

      # Open current command in Vim
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^x^e" edit-command-line

      # makes color constants available
      autoload -U colors
      colors
    '' + (builtins.readFile ./config/zshrc);
    plugins = [{
      name = "zinit";
      file = "zinit.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "zdharma-continuum";
        repo = "zinit";
        rev = "v3.12.0";
        hash = "sha256-AiYK1pRFD4CGvBcQg9QwgFjc5Z564TVlWW0MzxoxdWU=";
      };
    }];
  };

  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    subversion
    asdf-vm
    lua
  ];
}

