# hosts/YourHostName/default.nix
{ pkgs, ... }:
{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.defaults.dock.autohide = true;
  users.users.alex.home = "/Users/alex";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.alex = { pkgs, ... }: {
    home.stateVersion = "23.05";
    programs.tmux = { # my tmux configuration, for example
      enable = true;
      keyMode = "vi";
      clock24 = true;
      historyLimit = 10000;
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        gruvbox
      ];
      extraConfig = ''
        new-session -s main
        bind-key -n C-a send-prefix
      '';
    };
  };
  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "audacity"
      #"alfred" #you are on alfred4 not 5
      "balenaetcher"
      "discord"
      "element"
      "firefox"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "logitech-options"
      "istat-menus"
      "monitorcontrol"
      "nextcloud"
      "notion"
      "obsidian"
      "prusaslicer"
      "slack"
      "spotify"
      "steam"
      "viscosity"
      "visual-studio-code"
      "vlc"
    ];
  };

  nix = {
    #package = lib.mkDefault pkgs.unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

}