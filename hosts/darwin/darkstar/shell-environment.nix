{ config, pkgs, lib, ... }:

{
  # Shell environment configuration
  
  # Set system-wide environment variables
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less -R";
    LESS = "-R";
    CLICOLOR = "1";
    LSCOLORS = "ExGxBxDxCxEgEdxbxgxcxd";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  
  # Add system-wide shell aliases
  environment.shellAliases = {
    ll = "ls -la";
    la = "ls -a";
    l = "ls -l";
    g = "git";
    gc = "git commit";
    gs = "git status";
    gd = "git diff";
    gp = "git push";
    gl = "git pull";
    grep = "grep --color=auto";
    ip = "ipconfig getifaddr en0";
    pubip = "curl -s https://api.ipify.org";
    reload = "darwin-rebuild switch --flake .#darkstar";
  };
  
  # Configure default shell
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ bash zsh fish ];
  
  # Add shell integration for utilities
  programs.bash.completion.enable = true;
  programs.zsh.enableCompletion = true;
  
  # Configure system-wide shell init scripts
  environment.pathsToLink = [ "/share/zsh" ];
}
