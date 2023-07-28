# hosts/YourHostName/default.nix
{ pkgs, ... }:
{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    promptInit = (builtins.readFile ./../../data/mac-dot-zshrc);
  };

  users.users.alex.home = "/Users/alex";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.alex = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      mosh
      tmux
    ];
    programs.tmux = { # my tmux configuration, for example
      enable = true;
      #keyMode = "vi";
      clock24 = true;
      historyLimit = 10000;
      plugins = with pkgs.tmuxPlugins; [
      #   vim-tmux-navigator
        gruvbox
      ];
      extraConfig = ''
        new-session -s main
        bind-key -n C-a send-prefix
      '';
    };
  };

  fonts = {
     fonts = [ nerdfonts ];
     fontDir = {
       enable = true;
     };
  };

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 25;
    NSGlobalDomain.KeyRepeat = 4;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    finder.AppleShowAllExtensions = true;
    finder.FXEnableExtensionChangeWarning = false;
    loginwindow.GuestEnabled = false;
    dock.autohide = false;
    dock.launchanim = false;
    dock.static-only = false;
    dock.show-recents = false;
    dock.show-process-indicators = true;
    dock.orientation = "left";
    dock.tilesize = 38;
  };
  system.defaults.CustomUserPreferences = {
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.Safari" = {
        # Privacy: don’t send search queries to Apple
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
  };

  environment.systemPackages =
  [
    neovim
    nerdfonts
    pkgs.git
    pkgs.hugo
    pkgs.ibm-plex
    pkgs.jq
    pkgs.nmap
    pkgs.ripgrep
    pkgs.terraform
    pkgs.tmux
    pkgs.tree
    pkgs.unzip
    pkgs.wget
  ];

  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    taps = [
      "homebrew/cask-fonts"
    ];
    brews = [
      "mas" # mac app store cli
      "ansible"
      "ansible-lint"
      "bitwarden-cli"
      "coreutils"
      "esptool"
      "gh"
      "gnu-sed"
      "htop"
      "ipmitool"
      "jq"
      "midnight-commander"
      "nmap"
      "skopeo"
      "smartmontools"
      "terraform"
      "tree"
      "watch"
      "wget"
      "wireguard-tools"
    ];
    casks = [
      #"alfred" # you are on alfred4 not 5
      "audacity"
      "balenaetcher"
      "discord"
      "element"
      "firefox"
      "font-jetbrains-mono-nerd-font"
      "font-jetbrains-mono"
      "google-chrome"
      "istat-menus"
      "iterm2"
      "logitech-options"
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
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Creator's Best Friend" = 1524172135;
      "Disk Speed Test" = 425264550;
      "iA Writer" = 775737590;
      "Microsoft Remote Desktop" = 1295203466;
      "Reeder" = 1529448980;
      "Resize Master" = 1025306797;
      "Tailscale" = 1475387142;
      "Telegram" = 747648890;
      "The Unarchiver" = 425424353;
      "Todoist" = 585829637;
      "UTM" = 1538878817;
      "Wireguard" = 1451685025;

      # these apps with uk apple id
      #"Final Cut Pro" = 424389933;
      #"Logic Pro" = 634148309;
      #"MainStage" = 634159523; 
      #"Garageband" = 682658836;
      #"ShutterCount" = 720123827;
      #"Teleprompter" = 1533078079;

      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
    };
  };

  nix = {
    #package = lib.mkDefault pkgs.unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

}
